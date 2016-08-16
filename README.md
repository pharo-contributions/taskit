# TaskIT

>Anything that can go wrong, will go wrong. -- Murphy's Law

Expressing and managing concurrent computations is indeed a concern of importance to develop applications that scale. A web application may want to use different processes for each of its incoming requests. Or maybe it wants to use a "thread pool" in some cases. In other case, our desktop application may want to send computations to a worker to not block the UI thread. 

Processes in Pharo are implemented as green threads scheduled by the virtual machine, without depending on the machinery of the underlying operating system. This has several consequences on the usage of concurrency we can do:

- Processes are cheap to create and to schedule. We can create as many as them as we want, and performance will only degrade if the code executed in those processes do so, what is to be expected.
- Processes provide concurrent execution but no real parallelism. Inside Pharo, it does not matter the amount of processes we use. They will be always executed in a single operating system thread, in a single operating system process.

Also, besides how expensive it is to create a process, to know how we could organize the processes in our application, we need to know how to synchronize such processes. For example, maybe we need to execute two processes concurrently and we want a third one to wait the completion of the first two before starting. Or maybe we need to maximize the parallelism of our application while enforcing the concurrent access to some piece of state. And all these issues require avoiding the creation of deadlocks.

TaskIT is a library that ease Process usage in Pharo. It provides abstractions to execute and synchronize concurrent tasks, and several pre-built mechanisms that are useful for many application developers. This chapter explores starts by familiarizing the reader with TaskIT's abstractions, guided by examples and code snippets. At the end, we discuss TaskIT extension points and possible customizations.

## Downloading

> TODO

## Asynchronous Tasks

TaskIT's main abstraction are, as the name indicates it, tasks. A task is a unit of execution. By splitting the execution of a program in several tasks, TaskIT can run those tasks concurrently, synchronize their access to data, or order even help in ordering and synchronizing their execution.

### First Example

Launching a task is as easy as sending the message `schedule` to a block closure, as it is used in the following first code example:
```smalltalk
[ 1 + 1 ] schedule.
```
>The selector name `schedule` is chosen in purpose instead of others such as run, launch or execute. TaskIT promises you that a task will be *eventually* executed, but this is not necessarilly right away. In other words, a task is *scheduled* to be executed at some point in time in the future.

This first example is however useful to clarify the first two concepts but it remains too simple. We are schedulling a task that does nothing useful, and we cannot even observe it's result (*yet*). Let's explore some other code snippets that may help us understand what's going on.

The following code snippet will schedule a task that prints to the `Transcript`. Just evaluating the expression below will make evident that the task is actually executed. However, a so simple task runs so fast that it's difficult to tell if it's actually running concurretly to our main process or not.
```smalltalk
[ 'Happened' logCr ] schedule.
```
The real acid test is to schedule a long-running task. The following example schedules a task that waits for a second before writing to the transcript. While normal synchronous code would block the main thread, you'll notice that this one does not. 
```smalltalk
[ 1 second wait.
'Waited' logCr ] schedule.
```

### Schedule vs fork
You may be asking yourself what's the difference between the `schedule` and `fork`. From the examples above they seem to do the same but they do not. In a nutshell, to understand why `schedule` means something different than `fork`, picture that using TaskIT two tasks may execute inside a same process, or in a pool of processes, while `fork` creates a new process every time.

You will find a longer answer in the section below explaining *runners*. In TaskIT, tasks are not directly scheduled in Pharo's global `ProcessScheduler` object as usual `Process` objects are. Instead, a task is scheduled in a task runner. It is the responsibility of the task runner to execute the task.

### All valuables can be Tasks

We have been using so far block closures as tasks. Block closures are a handy way to create a task since they implictly capture the context: they have access to `self` and other objects in the scope. However, blocks are not always the wisest choice for tasks. Indeed, when a block closure is created, it references the current `context` with all the objects in it and its *sender contexts*, being a potential source of memory leaks.

The good news is that TaskIt tasks can be represented by almost any object. A task, in TaskIT's domain are **valuable objects** i.e., objects that will do some computation when they receive the `value` message. Actually, the message `schedule` is just a syntax sugar for:

```smalltalk
(TKTTask valuable: [ 1 logCr ]) schedule.
```

We can then create tasks using message sends or weak message sends:

```smalltalk
TKTTask valuable: (WeakMessageSend receiver: Object new selector: #yourself).
TKTTask valuable: (MessageSend receiver: 1 selector: #+ arguments: { 7 }).
```

Or even create our own task object:

```smalltalk
Object subclass: #MyTask
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'MyPackage'.

MyTask >> value
    ^ 100 factorial
```

and use it as follows:

```smalltalk
TKTTask valuable: MyTask new.
```

## Retrieving a Task's Result with Futures

In TaskIT we differentiate two different kind of tasks: some tasks are just *scheduled* for execution, they produce some side-effect and no result, some other tasks will produce (generally) a side-effect free value. When the result of a task is important for us, TaskIT provides us with a *future* object. A *future* is no other thing than an object that represents the future value of the task's execution. We can schedule a task with a future by using the `future` message on a block closure, as follows.

```smalltalk
aFuture := [ 2 + 2 ] future.
```

One way to see futures is as placeholders. When the task is finished, it deploys its result into the corresponding future. A future then provides access to its value, but since we cannot know *when* this value will be available, we cannot access it right away. Instead, futures provide an asynchronous way to access it's value by using *callbacks*. A callback is an object that will be executed when the task execution is finished.  

>In general terms, we do not want to **force** a future to retrieve his value in a synchronous way.
>By doing so, we would be going back to the synchronous world, blocking a process' execution, and not exploiting concurrency.
>Later sections will discuss about synchronous (blocking) retrieval of a future's value.

A future can provide two kind of results: either the task execution was a success or a failure. A success happens when the task completes in a normal way, while a failure happens when an uncatched exception is risen in the task. Because of these distinction, futures allow the subscription of two different callbacks using the methods `onSuccessDo:` and `onFailureDo:`.

In the example below, we create a future and subscribe to it a success callback. As soon as the task finishes, the value gets deployed in the future and the callback is called with it.
```smalltalk
aFuture := [ 2 + 2 ] future.
aFuture onSuccessDo: [ :result | result logCr ].
```
We can also subscribe callbacks that handle a task's failure using the `onFailureDo:` message. If an exception occurs and the task cannot finish its execution as expected, the corresponding exception will be passed as argument to the failure callback, as in the following example.
```smalltalk
aFuture := [ Error signal ] future.
aFuture onFailureDo: [ :error | error sender method selector logCr ].
```

Futures accept more than one callback. When its associated task is finished, all its callbacks will be *scheduled* for execution. In other words, the only guarantee that callbacks give us is that they will be all eventually executed. However, the future itself cannot guarantee neither **when** will the callbacks be executed, nor **in which order**. The following example shows how we can subscribe several success callbacks for the same future.

```smalltalk
future := [ 2 + 2 ] future.
future onSuccessDo: [ :v | FileStream stdout nextPutAll: v asString; cr ].
future onSuccessDo: [ :v | 'Finished' logCr ].
future onSuccessDo: [ :v | [ v factorial logCr ] schedule ].
future onFailureDo: [ :error | error logCr ].
```

Callbacks work wether the task is still running or already finished. If the task is running, callbacks are registered and wait for the completion of the task. If the task is already finished, the callback will be immediately scheduled with the already deployed value. See below a code examples that illustrates this: we first create a future and subscribes a callback before it is finished, then we  wait for its completion and subscribe a second callback afterwards. Both callbacks are scheduled for execution.

```smalltalk
future := [ 1 second wait. 2 + 2 ] future.
future onSuccessDo: [ :v | v logCr ].

2 seconds wait.
future onSuccessDo: [ :v | v logCr ].
```

## Task Runners: Controlling How Tasks are executed 

So far we created and executed tasks without caring too much on the form they were executed. Indeed, we knew that they were run concurrently because they were non-blocking. We also said already that the difference between a `schedule` message and a `fork` message is that scheduled messages are run by a **task runner**.

A task runner is an object in charge of executing tasks *eventually*. Indeed, the main API of a task runner is the `schedule:` message that allows us to tell the task runner to schedule a task.
```smalltalk
aRunner schedule: [ 1 + 1 ]
```

A nice extension built on top of schedule is the  `future:` message that allows us to schedule a task but obtain a future of its eventual execution.

```smalltalk
future := aRunner future: [ 1 + 1 ]
```

Indeed, the messages `schedule` and `future` we have learnt before are only syntax-sugar extensions that call these respective ones on a default task runner. This section discusses several useful task runners already provided by TaskIT.

### New Process Task Runner

A new process task runner, instance of `TKTNewProcessTaskRunner`, is a task runner that runs each task in a new separate Pharo process. 

```smalltalk
aRunner := TKTNewProcessTaskRunner new.
aRunner schedule: [ 1 second wait. 'test' logCr ].
```
Moreover, since new processes are created to manage each task, scheduling two different tasks will be executed concurrently. For example, in the code snippet below, we schedule twice a task that printing the identity hash of the current process.

```smalltalk
aRunner := TKTNewProcessTaskRunner new.
task := [ 10 timesRepeat: [ 10 milliSeconds wait.
				('Hello from: ', Processor activeProcess identityHash asString) logCr ] ].
aRunner schedule: task.
aRunner schedule: task.
```

The generated output will look something like this:

```
'Hello from: 887632640'
'Hello from: 949846528'
'Hello from: 887632640'
'Hello from: 949846528'
'Hello from: 949846528'
'Hello from: 887632640'
'Hello from: 949846528'
'Hello from: 887632640'
'Hello from: 949846528'
'Hello from: 887632640'
'Hello from: 949846528'
'Hello from: 887632640'
'Hello from: 949846528'
'Hello from: 887632640'
'Hello from: 949846528'
'Hello from: 887632640'
'Hello from: 949846528'
'Hello from: 887632640'
'Hello from: 949846528'
'Hello from: 887632640'
```

First, you'll see that a different processes is being used to execute each task. Also, their execution is concurrent, as we can see the messages interleaved.

### Local Process Task Runner

The local process runner, instance of `TKTLocalProcessTaskRunner`, is a task runner that executes a task in the caller process. In other words, this task runner does not run concurrently. Executing the following piece of code:
```smalltalk
aRunner := TKTLocalProcessTaskRunner new.
future := aRunner schedule: [ 1 second wait ].
```
is equivalent to the following piece of code:
```smalltalk
[ 1 second wait ] value.
```
or even:
```smalltalk
1 second wait.
```

While this runner may seem a bit naive, it may also come in handy to control and debug task executions. Besides, the power of task runners is that they offer a polymorphic API to execute tasks.

### The Worker Runner

The worker runner, instance of `TKTWorker`, is a task runner that uses a single process to execute tasks from a queue. The worker's single process removes one-by-one the tasks from the queue and executes them sequenceally. Then, schedulling a task into a worker means to add the task inside the queue.

A worker manages the life-cycle of its process and provides the messages `start` and `stop` to control when the worker thread will begin and end.

```smalltalk
worker := TKTWorker new.
worker start.
worker schedule: [ 1 + 5 ].
worker stop.
```

By using workers, we can control the amount of alive processes and how tasks are distributed amongst them. For example, in the following example three tasks are executed sequenceally in a single separate process while still allowing us to use an asynchronous style of programming.

```smalltalk
worker := TKTWorker new start.
future1 := worker future: [ 2 + 2 ].
future2 := worker future: [ 3 + 3 ].
future3 := worker future: [ 1 + 1 ].
```

Workers can be combined into *worker pools*. Worker pools are discussed in a later section.

### Managing Runner Exceptions

As we stated before, in TaskIT the result of a task can be interesting for us or not. In case we do not need a task's result, we will schedule it usign the `schedule` or `schedule:` messages. This is a kind of fire-and-forget way of executing tasks. On the other hand, if the result of a task execution interests us we can get a future on it using the `future` and `future:` messages. These two ways to execute tasks require different ways to handle exceptions during task execution.

First, when an exception occurs during a task execution that has an associated future, the exception is forwarded to the future. In the future we can subscribe a failure callback using the `onFailureDo:` message to manage the exception accordingly.

However, on a fire-and-forget kind of scheduling, the execution and results of a task is not anymore under our control. If an exception happens in this case, it is the responsibility of the task runner to catch the exception and manage it gracefully. For this, each task runners is configured with an exception handler in charge of it. TaskIT exception handler classes are subclasses of the abstract `TKTExceptionHandler` that defines a `handleException:` method. Subclasses need to override the `handleException:` method to define their own way to manage exceptions.

TaskIt provides by default a `TKTDebuggerExceptionHandler` that will open a debugger on the raised exception. The `handleException:` method is defined as follows:

```smalltalk
handleException: anError 
	anError debug
```

Changing a runner's exception handler can be done by sending it the `exceptionHandler:` message, as follows:

```smalltalk
aRunner exceptionHandler: TKTDebuggerExceptionHandler new.
```

## The Worker pool

A TaskIT worker pool is pool of worker runners, equivalent to a ThreadPool from other programming languages. Its main purpose is to provide several worker runners and decouple us from the management of threads/processes. A worker pool is a runner in the sense we use the `schedule:` message to schedule tasks in it. Internally, all runners inside a worker pool share a single task queue.

Different applications may have different concurrency needs, thus, TaskIT worker pools do not provide a default amount of workers. Before using a pool, we need to specify the maximum number of workers in the pool using the `poolMaxSize:` message. A worker pool will create new workers on demand. 
```smalltalk
pool := TKTWorkerPool new.
pool poolMaxSize: 5.
```
TaskIT worker pools use internally an extra worker to synchronize the access to its task queue. Because of this, a worker pool has to be manually started using the `start` message before scheduled messages start to be executed.
```smalltalk
pool := TKTWorkerPool new.
pool poolMaxSize: 5.
pool start.
pool schedule: [ 1 logCr ].
```

Once we are done with the worker pool, we can stop it by sending it the `stop` message.
```smalltalk
pool stop.
```

## Advanced Futures

### Where do futures and callbacks run

> TODO

### Future combinators

Futures are a nice asynchronous way to obtain the results of our eventually executed tasks. However, as we do not know when tasks will finish, processing that result will be another asynchronous task that needs to start as soon as the first one finishes. To simplify the task of future management, TaskIT futures come along with some combinators.

- **The `collect:` combinator**

The `collect:` combinator does, as its name says, the same than the collection's API: it transforms a result using a transformation.

```smalltalk
future := [ 2 + 3 ] future.
(future collect: [ :number | number factorial ])
    onSuccessDo: [ :result | result logCr ].
```

The `collect:` combinator returns a new future whose value will be the result of transforming the first future's value.

- **The `select:` combinator**

The `select:` combinator does, as its name says, the same than the collection's API: it filters a result satisfying a condition.

```smalltalk
future := [ 2 + 3 ] future.
(future select: [ :number | number even ])
    onSuccessDo: [ :result | result logCr ];
    onFailureDo: [ :error | error logCr ].
```

The `select:` combinator returns a new future whose result is the result of the first future if it satisfies the condition. Otherwise, its value will be a `NotFound` exception.

- **The `flatCollect:`combinator**

The `flatCollect:` combinator is similar to the `collect:` combinator, as it transforms the result of the first future using the given transformation block. However, `flatCollect:` excepts as the result of its transformation block a future.

```smalltalk
future := [ 2 + 3 ] future.
(future flatCollect: [ :number | [ number factorial ] future ])
    onSuccessDo: [ :result | result logCr ].
```
The `flatCollect:` combinator returns a new future whose value will be the result the value of the future yielded by the transformation.

- **The `zip:`combinator**

The `zip:` combinator combines two futures into a single future that returns an array with both results.

```smalltalk
future1 := [ 2 + 3 ] future.
future2 := [ 18 factorial ] future.
(future1 zip: future2)
    onSuccessDo: [ :result | result logCr ].
```
`zip:` works only on success: the resulting future will be a failure if any of the futures is also a failure.

- **The `on:do:`combinator**

The `on:do:` allows us to transform a future that fails with an exception into a future with a result.

```smalltalk
future := [ Error signal ] future
    on: Error do: [ :error | 5 ].
future onSuccessDo: [ :result | result logCr ].
```

- **The `fallbackTo:` combinator**

The `fallbackTo:` combinator combines two futures in a way such that if the first future fails, it is the second one that will be taken into account.

```smalltalk
failFuture := [ Error signal ] future.
successFuture := [ 1 + 1 ] future.
(failFuture fallbackTo: successFuture)
    onSuccessDo: [ :result | result logCr ].
```

In other words, `fallbackTo:` produces a new future whose value is the first's future value if success, or it is the second future's value otherwise. 

- **The `firstCompleteOf:` combinator**

The `firstCompleteOf:` combinator combines two futures resulting in a new future whose value is the value of the future that finishes first, wether it is a success or a failure.

```smalltalk
failFuture := [ 1 second wait. Error signal ] future.
successFuture := [ 1 second wait. 1 + 1 ] future.
(failFuture firstCompleteOf: successFuture)
    onSuccessDo: [ :result | result logCr ];
    onFailureDo: [ :error | error logCr ].
```

In other words, `fallbackTo:` produces a new future whose value is the first's future value if success, or it is the second future's value otherwise.

- **The `andThen:` combinator**

The `andThen:` combinator allows to chain several futures to a single future's value. All futures chained using the `andThen:` combinator are guaranteed to be executed sequenceally (in contrast to normal callbacks), and all of them will receive as value the value of the first future (instead of the of of it's preceeding future).

```smalltalk
([ 1 + 1 ] future
    andThen: [ :result | result logCr ])
    andThen: [ :result | FileStream stdout nextPutAll: result ]. 
```

This combinator is meant to enforce the order of execution of several actions, and this it is mostly for side-effect purposes where we want to guarantee such order.

### Synchronous Access

Sometimes, although we do not recommend it, you will need or want to access the value of a task in a synchronous manner: that is, to wait for it. We do not recommend waiting for a task because of several reasons:
  - sometimes you do not know how much a task will last and therefore the waiting can kill's your application's responsiveness
  - also, it will block your current process until the waiting is finished
  - you come back to the synchronous world, killing completely the purpose of using TaskIT :)

However, since experienced users may still need this feature, TaskIT futures provide three different messages to access synchronously its result: `isFinished`, `waitForCompletion:` and `synchronizeTimeout:`.

`isFinished` is a testing method that we can use to test if the corresponding future is still finished or not. The following piece of code shows how we could implement an active wait on a future:

```smalltalk
future := [1 second wait] future.
[future isFinished] whileFalse: [50 milliseconds wait].
```

An alternative version for this code that does not require an active wait is the message `waitForCompletion:`. `waitForCompletion:` expects a duration as argument that he will use as timeout. This method will block the execution until the task finishes or the timeout expires, whatever comes first. If the task did not finish by the timeout, a `TKTTimeoutException` will be raised.

```smalltalk
future := [1 second wait] future.
future waitForTimeout: 2 seconds.

future := [1 second wait] future.
[future waitForTimeout: 50 milliSeconds] on: TKTTimeoutException do: [ :error | error logCr ].
```

Finally, to retrieve the future's result, futures understand the `synchronizeTimeout:` message, that receives a duration as argument as its timeout. If a successful value is available by the timeout, then the result is returned. If the task finished by the timeout with a failure, an `UnhandledError` exception is raised wrapping the original exception. Otherwise, if the task is not finished by the timeout a `TKTTimeoutException` is raised.

```smalltalk
future := [1 second wait. 42] future.
(future synchronizeTimeout: 2 seconds) logCr.

future := [ self error ] future.
[ future synchronizeTimeout: 2 seconds ] on: Error do: [ :error | error logCr ].

future := [ 5 seconds wait ] future.
[ future synchronizeTimeout: 1 seconds ] on: TKTTimeoutException do: [ :error | error logCr ].
```

## Services

>TODO

## TODOs

- Write about services
- ConfigurationOf
- Examples?
- ActIt2