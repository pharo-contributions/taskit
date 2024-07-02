
# TaskIt

[![Tests](https://github.com/pharo-contributions/taskit/actions/workflows/tests.yml/badge.svg)](https://github.com/pharo-contributions/taskit/actions/workflows/tests.yml)

>Anything that can go wrong, will go wrong. — Murphy's Law

Managing concurrency is a significant challenge when developing applications that scale. For a web application, we may want to use different processes for each incoming requests or we may want to use a [thread pool](https://en.wikipedia.org/wiki/Thread_pool). For a desktop application, we may want to do long-running computations in the background to avoid blocking the UI. 

"Processes" in Pharo are implemented as [green threads](https://en.wikipedia.org/wiki/Green_thread) that are scheduled by the virtual machine rather than the underlying operating system. This has advantages and disadvantages:

- Processes are cheap to create and to schedule. We can create as many as them as we want, and performance depends on the code executed in those processes with very little process management overhead.
- While processes provide _concurrent_ execution, there is no real _parallelism_. Inside Pharo, however many processes we use, they will be always executed in a single operating system thread, in a single operating system process.

When managing the processes in our application, we need to know how to synchronize these processes. For example, we may  want to execute two processes concurrently and have a third one wait for the completion of the first two before starting. Or maybe we want to maximize the parallelism of our application while enforcing concurrent access to some piece of state. And with all of this, we need to avoid deadlocks—a common problem with concurrency.

**TaskIt** is a Pharo library that provides abstractions to execute and synchronize concurrent tasks. This chapter starts by introducing TaskIt's abstractions using examples and code snippets and finishes with a discussion of TaskIt extension points and possible customizations.

## Introduction

Since version 9, Pharo's default image includes the `coreTests` group of `BaselineOfTaskIt`. The following instructions explain how to to load another group or load TaskIt in previous Pharo versions.

### Loading

If you want a specific release such as v1.0, you can load the associated tag as follows:

```smalltalk
Metacello new
  baseline: 'TaskIt';
  repository: 'github://pharo-contributions/taskit:v1.0';
  load.
```

Otherwise, if you want the latest development version, load master:

```smalltalk
Metacello new
  baseline: 'TaskIt';
  repository: 'github://pharo-contributions/taskit';
  load.
```


#### Adding TaskIt as a Metacello dependency

To add TaskIt to an existing applocation, add the following to your Metacello configuration or baseline with the desired version:

```smalltalk
spec
    baseline: 'TaskIt'
    with: [ spec repository: 'github://pharo-contributions/taskit:v1.0' ]
```

#### For developers

TaskIt code is on [GitHub](https://github.com/pharo-contributions/taskit) and we use [Iceberg](https://github.com/pharo-vcs/iceberg.git) for source code management. Just load Iceberg and enter GitHub's url to clone. Remember to switch to the desired development branch or create one on your own.

## Asynchronous Tasks

TaskIt's main abstraction are, as the name implies, tasks. A task is a unit of execution. If you split the execution of a program in several tasks, TaskIt can run those tasks concurrently, synchronize their access to data, and even help in ordering and synchronizing their execution.

### First Example

Launching a task is as easy as sending the message `schedule` to a block closure:
```smalltalk
[ 1 + 1 ] schedule.
```
>The selector `schedule` is used instead of `run`, `launch`, or `execute` to emphasize that a task will *eventually* be executed. In other words, a task is *scheduled* to be executed at some point in the future.

While a convenient demo, this first example is too simple. We are schedulling a task that does nothing useful, and we cannot even observe it's result (*yet*). Let's explore some other code snippets that clarify what's going on. The following code snippet will schedule a task that prints to the `Transcript`. Evaluating the expression shows that the task is actually executed. 
```smalltalk
[ 'Happened' logCr ] schedule.
```
However, a trivial task runs so fast that it's difficult to tell if it's actually running concurretly to our main process or not. A better example is to schedule a long-running task. The following example schedules a task that waits for a second before writing to the transcript. While normal synchronous code would block the main thread, you'll notice that this one does not. 
```smalltalk
[ 1 second wait.
'Waited' logCr ] schedule.
```

### Schedule vs fork
You may wonder what's different between TaskIt's `schedule` and the built-in `fork`. From the examples above they seem equivalent. The short answer is that `fork` creates a new process every time it is called while `schedule` allows much more control: two tasks may execute (sequentially) inside a single process or (concurrently) in a pool of processes.

You will find a longer answer in the section below explaining *runners*. Briefly, TaskIt tasks are not directly scheduled in Pharo's global `ProcessScheduler` as usual `Process` objects are. Instead, a task is scheduled in a task runner. It is the responsibility of the task runner to execute the task.

### All valuables can be Tasks

So far we have been using block closures to define tasks. Block closures are a handy way to create a task since they implictly capture the context ( they have access to `self` and other objects in the scope). However, blocks are not always the wisest choice for tasks because each block references the current `context` with all the objects in it and its *sender contexts*, objects that might otherwise be garbage collected.

The good news is that TaskIt tasks can be represented by almost any object. A task, in TaskIt's domain are **valuable objects**, i.e., objects that will do some computation when they receive the `value` message. Actually, the message `schedule` in the above example is just a syntax sugar for:

```smalltalk
(TKTTask valuable: [ 'Happened' logCr ]) schedule.
```

We can then create tasks using any object that understands `value` (such as `MessageSend`):

```smalltalk
TKTTask valuable: (MessageSend receiver: 1 selector: #+ arguments: { 7 }).
```

We can even create our own task object:

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

A task can compute a value (such as the `1 + 1` example), or it can have a side-effect (such as printing to the Transcript), or it can have both a result and side-effect (while a task could do neither, that is not very useful!). When the result of a task is important to us (or we just want to know when it is done), we use TaskIt's *future* object. A [*future*](https://en.wikipedia.org/wiki/Futures_and_promises) is simply an object that represents the future value of the task's execution. We can schedule a task and obtain a future by using the `future` message on a block closure, as follows.

```smalltalk
aFuture := [ 2 + 2 ] future.
```

One way to see a future is as a placeholder. When a task is finished, it provides its result to its corresponding future. A future then provides access to the task's value—but since we cannot know *when* this value will be available, we cannot access it right away. We can either wait (blocking or synchronous) for the result or we can register a *callback* to be executed asynchronously when the task execution is finished.  

>In general, *blocking* on a future should be avoided in the UI thread. In a background (non-UI) thead, however, blocking may be compeletely appropriate and this will be covered in later sections.

Like any other code, a task can complete normally or with an unhandled exception. A future supports these possibilities with callbacks using the methods `onSuccessDo:` and `onFailureDo:`. In the example below, we create a future and assign to it a success callback. As soon as the task finishes, the value gets deployed in the future and the callback is called with the resulting value.
```smalltalk
aFuture := [ 2 + 2 ] future.
aFuture onSuccessDo: [ :result | result logCr ].
```
We can also assign callbacks that handle a task's failure using the `onFailureDo:` message. If an exception occurs and the task cannot finish its execution as expected, the corresponding exception will be passed as argument to the failure callback, as in the following example.
```smalltalk
aFuture := [ Error signal ] future.
aFuture onFailureDo: [ :error | error sender method selector logCr ].
```

Futures accept more than one callback. When a task is finished, all its callbacks will be *scheduled* for (eventual) execution. There is no guarantee of the **timing** or **order** of the execution. The following example shows how we can register several success callbacks for the same future.

```smalltalk
future := [ 2 + 2 ] future.
future onSuccessDo: [ :v | FileStream stdout nextPutAll: v asString; cr ].
future onSuccessDo: [ :v | 'Finished' logCr ].
future onSuccessDo: [ :v | [ v factorial logCr ] schedule ].
future onFailureDo: [ :error | error logCr ].
```

Callbacks can be registered while the task is still running as well as after it finishes. If the task is running, callbacks are saved and wait for the completion of the task. If the task is already finished, the callback will be immediately scheduled with the previously computed value. The following example illustrates this: we first create a future and register a callback before it is finished, then we  wait for its completion and register a second callback afterwards. Both callbacks are scheduled for execution.

```smalltalk
future := [ 1 second wait. 2 + 2 ] future.
future onSuccessDo: [ :v | v logCr ].

2 seconds wait.
future onSuccessDo: [ :v | v logCr ].
```

## Task Runners: Controlling How Tasks are executed 

So far we have created and executed tasks without regard to how they were executed—except that we knew that they were run concurrently because they were non-blocking. Earlier we said that the difference between a `schedule` message and a `fork` message is that scheduled messages are run by a **task runner**. We now explore that concept in more detail.

A task runner is an object in charge of executing tasks *eventually*. Indeed, the main API of a task runner is the `schedule:` message that allows us to tell the task runner to schedule a task.
```smalltalk
aRunner schedule: [ 1 + 1 ]
```

An alternative to `schedule:` is the  `future:` message that allows us to schedule a task but obtain a future of its eventual execution.

```smalltalk
future := aRunner future: [ 1 + 1 ]
```

Indeed, the messages `schedule` and `future` when sent to a block are only syntax-sugar extensions that call these respective ones on a default task runner. This section discusses several useful task runners provided by TaskIt.

### New Process Task Runner

A new process task runner, instance of `TKTNewProcessTaskRunner`, is a task runner that runs each task in a new separate Pharo process (analogous to the `fork` message). 

```smalltalk
aRunner := TKTNewProcessTaskRunner new.
aRunner schedule: [ 1 second wait. 'test' logCr ].
```
Moreover, since a `TKTNewProcessTaskRunner` creates a new process for each task, these tasks will be executed concurrently. For example, in the code snippet below, we schedule a task twice that printing the identity hash of the current process.

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

First, you'll see that two processes are being used to execute the two tasks. Also, their execution is concurrent, and we can see the messages interleave in an undefined order.

### Local Process Task Runner

The local process runner, an instance of `TKTLocalProcessTaskRunner`, is a task runner that executes a task in the caller process. In other words, this task runner does not run concurrently. Executing the following piece of code:
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

While this runner may seem a bit naive, it may also come in handy to control and debug task executions. Besides, the power of task runners is that they offer a polymorphic API to execute tasks (so you can substitute one runner for another).

### The Worker Runner

The worker runner, an instance of `TKTWorker`, is a task runner that uses a single process to execute tasks from a queue. The worker's single process removes tasks one at a time from a queue and executes them sequentially. Thus, we schedule a task into a worker by adding the task to the worker's queue.

A worker manages the life-cycle of its process and provides the messages `start` and `stop` to control when the worker is active.

```smalltalk
worker := TKTWorker new.
worker start.
worker schedule: [ 1 + 5 ].
worker stop.
```

By using workers, we can control the number of active processes and how tasks are distributed amongst them. For example, in the following example three tasks are executed sequenceally in a single separate process while still allowing us to use an asynchronous style of programming.

```smalltalk
worker := TKTWorker new start.
future1 := worker future: [ 2 + 2 ].
future2 := worker future: [ 3 + 3 ].
future3 := worker future: [ 1 + 1 ].
```

Workers can be combined into *worker pools*.


### The Worker pool

A TaskIt worker pool is pool of worker runners, equivalent to a [thread pool](https://en.wikipedia.org/wiki/Thread_pool) from other programming languages. Its main purpose is to encapsulate several worker runners and handle threads/processes management for us. A worker pool is a runner in the sense we use the `schedule:` message to schedule tasks in it. 

TaskIt has two kind of worker pools: 

 * TKTWorkerPool  
 * TKTCommonQueueWorkerPool


#### TKTWorkerPool

Each runner inside a TKTWorkerPool pool has its own task queue. The pool is in charge of assigning tasks to one of the available workers, taking into account the workload of each worker. 

Different applications may have different concurrency needs so TaskIt worker pools do not provide a default number of workers. Before using a pool, we need to specify the maximum number of workers in the pool using the `poolMaxSize:` message. A worker pool will create new workers (up to the specified maximum) on demand. 
```smalltalk
pool := TKTWorkerPool new.
pool poolMaxSize: 5.
```
Like the basic `TKTWorker`, a worker pool has to be manually started using the `start` message before scheduled messages start to be executed.
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


#### TKTCommonQueueWorkerPool

Internally, all runners inside a TKTCommonQueueWorkerPool pool share a common queue. This pool comes with a watchdog that ensures that all the workers are alive and reduces the number of workers when the load of work goes down. 


As with a `TKTWorkerPool`, before using a `TKTCommonQueueWorkerPool` we need to specify the maximum number of workers in the pool using the `poolMaxSize:` message. A worker pool will create new workers (up to the specified maximum) on demand. 
```smalltalk
pool := TKTCommonQueueWorkerPool new.
pool poolMaxSize: 5.
```
As before, a worker pool has to be manually started using the `start` message before scheduled messages are executed.
```smalltalk
pool := TKTCommonQueueWorkerPool new.
pool poolMaxSize: 5.
pool start.
pool schedule: [ 1 logCr ].
```

Once we are done with the worker pool, we can stop it by sending it the `stop` message.
```smalltalk
pool stop.
```

### Managing Runner Exceptions

As stated above, a task might or might not be intended to generate a result. In the case where we do not expect a result, we use the `schedule` or `schedule:` messages. This is a kind of fire-and-forget way of executing tasks. On the other hand, if the result of a task execution interests us we can get a future on it using the `future` and `future:` messages. These two ways to execute tasks require different ways to handle exceptions during task execution.

First, when an exception occurs during a task execution that has an associated future, the exception is forwarded to the future. In the future we can register a failure callback using the `onFailureDo:` message to manage the exception accordingly.

However, on a fire-and-forget kind of task, responsibility for handling task exceptions falls to the task runner and it must catch the exception and handle it gracefully. To do this, each task runner is configured with an exception handler. TaskIt exception handler classes are subclasses of the abstract `TKTExceptionHandler` that defines a `handleException:` method. Subclasses need to override the `handleException:` method to define their own way to manage exceptions.

TaskIt provides a `TKTDebuggerExceptionHandler`, accessible from the configuration `TKTConfiguration errorHandler` that will open a debugger on the raised exception. The `handleException:` method is defined as follows:

```smalltalk
handleException: anError 
	anError debug
```

Changing a runner's exception handler can be done by sending it the `exceptionHandler:` message, as follows:

```smalltalk
aRunner exceptionHandler: TKTDebuggerExceptionHandler new.
```

### Task Timeout

TaskIt tasks can be optionally schedulled with a execution time timeout. If the task has not completed within the specified duration, the task is terminated and an exception is raised. This behaviour is desirable because a long running tasks may indicate a problem, or it can just affect the responsiveness of our application.

A task's timeout can be provided while scheduling a task in a runner, using the `schedule:timeout:` message, asFollows: 
```smalltalk
aRunner schedule: [1 second wait] timeout: 50 milliSeconds.
```
A task's duration timeout must not be confused with a future's synchronous access timeout (*explained below*). The task timeout governs the task execution, while a future's timeout governs only the access to the future value and has no impact on the task itself.

### Where do tasks and callbacks run by default?

We suggested earlier that the `schedule` and `future` messages will schedule a task implicitly in a *default* task runner. To be more precise, it is not a default task runner but the **current task runner** that is used. In other words, task scheduling is context sensitive: if a task A is being executed by a task runner R, new tasks scheduled by A are implicitly scheduled R. The only exception to this is when there is no such task runner, i.e., when the task is scheduled from, for example, a workspace. In that case a default task runner is chosen for scheduling.

> Note: In the current version of taskit (v1.0) the default task runner is the global worker pool that can be explicitly accessed evaluating the following expression `TKTConfiguration runner`.

Something similar happens with callbacks. Before we said that callbacks are eventually and concurrently executed. This happens because callbacks are scheduled as normal tasks after a task's execution. This scheduling follows the rules from above: callbacks will be scheduled in the task runner where it's task was executed.

## Advanced Futures

### Future combinators

Futures are a nice asynchronous way to obtain the results of our eventually executed tasks. However, as we do not know when tasks will finish, processing that result will be another asynchronous task that starts after the first one finishes. To simplify the task of future management, TaskIt futures come along with some combinators.

- **The `collect:` combinator**

The `collect:` combinator is named for `Collection>>collect:` and transforms a result using a transformation task. Note that unlike its [protonym](https://en.wiktionary.org/wiki/protonym), this method evaluates the argument task exactly once (instead of once for each element in a collection). The `collect:` combinator returns a new future whose value will be the result of transforming the first future's value.

```smalltalk
future := [ 2 + 3 ] future.
(future collect: [ :number | number factorial ])
    onSuccessDo: [ :result | result logCr ].
```

- **The `select:` combinator**

The `select:` combinator is named for `Collection>>select:`, but is evaluates its argument task exactly once and returns either the original value (if the condition task returns `true`) or it signals an exception (if the condition task returns `false`). The `select:` combinator returns a new future whose result is the result of the first future if it satisfies the condition. Otherwise, its value will be a `NotFound` exception.

```smalltalk
future := [ 2 + 3 ] future.
(future select: [ :number | number even ])
    onSuccessDo: [ :result | result logCr ];
    onFailureDo: [ :error | error logCr ].
```

- **The `flatCollect:`combinator**

The `flatCollect:` combinator is similar to the `collect:` combinator in that it transforms the result of the first future using the given transformation block. However, `flatCollect:` differs in that the result of its transformation block is a future. The `flatCollect:` combinator returns a new future whose value will be the result the value of the future yielded by the transformation.

```smalltalk
future := [ 2 + 3 ] future.
(future flatCollect: [ :number | [ number factorial ] future ])
    onSuccessDo: [ :result | result logCr ].
```

- **The `zip:`combinator**

The `zip:` combinator combines two futures into a single future that returns an array with both results. `zip:` works only on success: the resulting future will be a failure if any of the futures is also a failure.

```smalltalk
future1 := [ 2 + 3 ] future.
future2 := [ 18 factorial ] future.
(future1 zip: future2)
    onSuccessDo: [ :result | result logCr ].
```

- **The `on:do:`combinator**

The `on:do:` allows us to transform a future that fails with an exception into a future with a result.

```smalltalk
future := [ Error signal ] future
    on: Error do: [ :error | 5 ].
future onSuccessDo: [ :result | result logCr ].
```

- **The `fallbackTo:` combinator**

The `fallbackTo:` combinator combines two futures in a way such that if the first future fails, it is the second one that will be taken into account. In other words, `fallbackTo:` produces a new future whose value is the first's future value if success, or it is the second future's value otherwise.

```smalltalk
failFuture := [ Error signal ] future.
successFuture := [ 1 + 1 ] future.
(failFuture fallbackTo: successFuture)
    onSuccessDo: [ :result | result logCr ].
```

- **The `firstCompleteOf:` combinator**

The `firstCompleteOf:` combinator combines two futures resulting in a new future whose value is the value of the future that finishes first, wether it is a success or a failure. 

```smalltalk
failFuture := [ 1 second wait. Error signal ] future.
successFuture := [ 1 second wait. 1 + 1 ] future.
(failFuture firstCompleteOf: successFuture)
    onSuccessDo: [ :result | result logCr ];
    onFailureDo: [ :error | error logCr ].
```

- **The `andThen:` combinator**

The `andThen:` combinator allows you to chain several futures to a single future's value. All futures chained using the `andThen:` combinator are guaranteed to be executed sequenceally (in contrast to normal callbacks), and all of them will receive as value the value of the first future (instead of the of of it's preceeding future). This combinator is meant to enforce the order of execution of several actions, and this it is mostly for side-effect purposes where we want to guarantee such order.

```smalltalk
([ 1 + 1 ] future
    andThen: [ :result | result logCr ])
    andThen: [ :result | FileStream stdout nextPutAll: result ]. 
```

### Synchronous Access

In a background (non-UI) thread you might want to access the value of a task in a synchronous manner—that is, to wait for it. TaskIt futures provide three different methods help with syncronization: `isFinished`, `waitForCompletion:` and `synchronizeTimeout:`.

`isFinished` is a testing method that we can use to test if the corresponding future is finished or not. The following code shows how we could implement an active wait on a future:

```smalltalk
future := [1 second wait] future.
[future isFinished] whileFalse: [50 milliseconds wait].
```

An alternative approach that does not require an explicit loop and `wait` is the message `waitForCompletion:`. `waitForCompletion:` expects a timeout (duration) as argument. This method will block until the task finishes or the timeout expires, whatever comes first. If the task did not finish by the timeout, a `TKTTimeoutException` will be raised.

```smalltalk
future := [1 second wait] future.
future waitForTimeout: 2 seconds.

future := [1 second wait] future.
[future waitForTimeout: 50 milliSeconds] on: TKTTimeoutException do: [ :error | error logCr ].
```

Finally, futures understand the `synchronizeTimeout:` message that also receives a timeout (duration). The difference is in the return value—while `waitForCompletion:` returns the future, `synchronizeTimeout:` returns one of three things:
- If a value is available by the timeout then that value is returned.
- If the task finished by the timeout with a failure then an `UnhandledError` exception is raised wrapping the original exception).
- If the task is not finished by the timeout then a `TKTTimeoutException` is raised.

The following code demonstrates each possibility:
```smalltalk
future := [1 second wait. 42] future.
(future synchronizeTimeout: 2 seconds) logCr.

future := [ self error ] future.
[ future synchronizeTimeout: 2 seconds ] on: Error do: [ :error | error logCr ].

future := [ 5 seconds wait ] future.
[ future synchronizeTimeout: 1 seconds ] on: TKTTimeoutException do: [ :error | error logCr ].
```

## Services

TaskIt furnishes a package implementing services. A service is a process that executes a task over and over again. You can think about a web server, or a database server that needs to be up and running and listening to new connections all the time.

Each TaskIt service may define a `setUp`, a `tearDown` and a `stepService`. `setUp` is run when a service is being started, `shutDown` is run when the service is being shut down, and `stepService` is the main service action that will be executed repeateadly.

Creating a new service is as easy as creating a subclass of `TKTService`. For example, let's create a service that watches the existence of a file. If the file does not exists it will log it to the transcript. It will also log when the service starts and stops to the transcript.

```smalltalk
TKTService subclass: #TKTFileWatcher
  instanceVariableNames: 'file'
  classVariableNames: ''
  package: 'TaskItServices-Tests'
```

Hooking on the service's `setUp` and `tearDown` is as easy as overriding such methods:

```smalltalk
TKTFileWatcher >> setUp
  super setUp.
  Transcript show: 'File watcher started'.

TKTFileWatcher >> tearDown
  super tearDown.
  Transcript show: 'File watcher finished'.
```

Finally, setting the watcher action is as easy as overriding the `stepService` message.

```smalltalk
TKTFileWatcher >> stepService
  1 second wait.
  file asFileReference exists
    ifFalse: [ Transcript show: 'file does not exist!' ]
```
This `stepService` method will be called repeatedly untill the service is stopped or killed (discussed below).

Making the service work requires yet an additional method: the service name. Each service should provide a unique name through the `name` method. TaskIt verifies that service names are unique and prevents the starting of two services with the same name.

```smalltalk
TKTFileWatcher >> name
  ^ 'Watcher file: ', file asString
```

Once your service is defined, starting it is as easy as sending it the `start` message.

```smalltalk
watcher := TKTFileWatcher new.
watcher file: 'temp.txt'.
watcher start.
```

Requesting the stop of a service is done by sending it the `stop` message. Note that sending the `stop` message will not stop the service right away. It will actually request it to stop, which will schedule the tear down of the service and kill its process after that. 

```smalltalk
watcher stop.
```

Stopping the process in an unsafe way is also supported by sending it the `kill` message. Killing a service will stop it right away, interrupting whatever task it was executing.

```smalltalk
watcher kill.
```

### Creating Services with Blocks

Additionally, TaskIt provides an alternative means to create services through blocks (or valuables actually) using `TKTParameterizableService`. An alternative implementation of the file watcher could be done as follows.

```smalltalk
service := TKTParameterizableService new.
service name: 'Generic watcher service'.
service onSetUpDo: [ Transcript show: 'File watcher started' ].
service onTearDownDo: [ Transcript show: 'File watcher finished' ].
service step: [
  'temp.txt' asFileReference exists
    ifFalse: [ Transcript show: 'file does not exist!' ] ].

service start.
```

## ActIt
**ActIt is only available for Pharo 7 and later since it requires stateful traits support.**

### Actors
The [actor model](https://en.wikipedia.org/wiki/Actor_model) treats everything as an actor and communication is by asyncronous messages. Our implementation is inspired by "Actalk: a Testbed for Classifying and Designing Actor Languages in the Smalltalk-80 Environment", but is adapted to Pharo's statefull traits. 

### How to use it

The trait `TKTActorBehaviour` extends a class by adding the message `actor`. This `actor` message will return an instance of the class `TKTActor` which will act as a proxy (managed by `doesnotUnderstand:`) to the object, but transforms each message to the object into a task, to be executed _sequentially_.

Each message sent to the actor will return a *future*. To make your domain object become an actor, add the trait `TKTActorBehaviour` as following:

```smalltalk
Object subclass: #MyDomainObject
	uses: TKTActorBehaviour
	instanceVariableNames: 'value'
	classVariableNames: ''
	package: 'MyDomainObjectPack'


myObject := MyDomainObject new. 
myObject setValue: 2.

self assert: myObject getValue equals: 2.

myActor := myObject actor.
self assert:( myActor getValue isKindOf: TKTFuture).
self assert:( myActor getValue synchronizeTimeout: 1 second) = myObject getValue. 
 
```

### How to act
 
  Simply adding this trait is not enough to make your Object into an Actor. 
  You need to remember that that any time that you reference `self` in your object, you are doing a synchronous call to the object, not the actor proxy. Also, each time that you give your object's reference as an argument in a message send, instead of the actor's reference, your object will work as a classic object as well.
  
  To allow the object to do an async call to self or pass the actor as an argument, the trait provides the propery `aself` (Async-self). 
  
  Remember also that even though actors provide a nice way to implement asyncronous behavior, they do not fully avoid deadlocks since the interaction in between actors is:
  - possible
  - desirable 
  - not directly managed 
  
## Process dashboard 
**Note that these instructions no longer work for Pharo 12 (and possibly earlier).**

TaskIt provides an enhanced process dashboard based on announcements. To access this dashboard, go to World menu > TaskIt > Process dashboard, as showed in the following image. 

![Please add an issue. Image is not loading!](images/AccessMenu.png)

The window has two tabs. 

### TaskIt tab 
The first shows the processes launched by TaskIt:

![Please add an issue. Image is not loading!](images/FirstScreen.png)

The showed table has six fields. 
- \# ordinal number. Just for easing the reading.
- Name: The name of the task. If none name was given it generates a name based on the related objects. 
- Sending: The selector of the method that executes the task. If the task is based on a block, it will be #value. 
- To: The receiver of the message that executes the task. 
- With: The arguments of the message send that executes the task
- State: [Running|NotRunning].

Some of those fields have attached some contextual menu. 

Right-click on the name of a process to interact with the process
![Please add an issue. Image is not loading!](images/ProcessMenu.png)

The options given are
- Inspect the process: It opens an inspector showing the related TaskIt process.
- Suspend|Resume the process: It will pause|resume the selected process. 
- Cancel the process: It cancel the process execution.  


Right-click on a the message selector to interact with a selector|method
![Please add an issue. Image is not loading!](images/SelectorInspection.png)

The options given are
- Method. This option browses the method executed by the task.
- Implementors. This option browses all the implementors of this selector. 

Finally, right-click on the receiver to interact with it
![Please add an issue. Image is not loading!](images/ReceiverInspector.png)

The option given is
-  Inspect receiver. This menu option does exactly that—it inspects the receiver of the message. 

###System tab

Finally, to allow the user to use just one interface. There is a second tab that shows the processes that were not spawnend by TaskIt. 

![Please add an issue. Image is not loading!](images/SystemScreen.png)

### Based on announcements 
  
   The TaskIt browser is based on announcements, allowing the interface to be dynamic (always having current information), without needing a polling process (as in the native process browser).

## Debugger

TaskIt comes with a debugger extension for Pharo that can be installed by loading the 'debug' group of the baseline (the debugger is not loaded by any other group):

```smalltalk
Metacello new
  baseline: 'TaskIt';
  repository: 'github://pharo-contributions/taskit';
  load: 'debug'.
```

After installation the TaskIt debugger extension will automatically be available to processes that are associated with a task or future. You can manually enable or disable the debugger extension by evaluating `TKTDebugger enable.` or `TKTDebugger disable.`.

The TaskIt debugger shows an augmented stack, in which the process that represents the task or future is at the top and the process that created the task or future is at the bottom (recursively for tasks and futures created from other tasks and futures). The following visualisation shows one future process (top) with frames `1` and `2` and the corresponding creator process (frames `3` and `4`):

```
-------------------
|     frame 1     |
-------------------
|     frame 2     |
-------------------
-------------------
|     frame 3     |
-------------------
|     frame 4     |
-------------------
```
The implementation and conception of this debugger extension can be found in Max Leske's Master's thesis entitled ["Improving live debugging of concurrent threads"](http://scg.unibe.ch/scgbib?query=Lesk16a&display=abstract).

## Configuration

TaskIt configuration is based on the idea of profiles. A profile define some major features needed by the library to work properly.

### TKTProfile
Defines the default profiles (on the class side), along with with the default profile to use.

```smalltalk
defaultProfile
	^ #development
	
development
	<profile: #development>
	^ TKTProfile
		on:
			{(#debugging -> true).
			(#runner -> TKTCommonQueueWorkerPool createDefault).
			(#poolWorkerProcess -> TKTDebuggWorkerProcess).
			(#process -> TKTRawProcess).
			(#errorHandler -> TKTDebuggerExceptionHandler).
			(#processProvider -> TKTTaskItProcessProvider new).
			(#serviceManager -> TKTServiceManager new)} asDictionary

production
	<profile: #production>
	^ TKTProfile
		on:
			{
			(#debugging -> false).
			(#runner -> TKTCommonQueueWorkerPool createDefault).
			(#poolWorkerProcess -> TKTWorkerProcess).
			(#process -> Process).
			(#errorHandler -> TKTExceptionHandler).
			(#processProvider -> TKTPharoProcessProvider new).
			(#serviceManager -> TKTServiceManager new)} asDictionary

test
	<profile: #test>
	^ TKTProfile
		on:
			{(#debugging -> false).
			(#runner -> TKTCommonQueueWorkerPool createDefault).
			(#poolWorkerProcess -> TKTWorkerProcess).
			(#process -> Process).
			(#errorHandler -> TKTExceptionHandler).
			(#processProvider -> TKTTaskItProcessProvider new).
			(#serviceManager -> TKTServiceManager new)} asDictionary
```

- **Modifying the running profile** 

There are three ways of modifying the running profile.
  
**The first** one and simplest, is to go to the *settings browser* and choose the available profile in the section 'TaskIt execution profile'. In this combo box you will find all the predefined profiles. 

**The second** way is to use code
  
 ```smalltalk
 	TKTConfiguration profileNamed: #development 
 ```
The method profileNamed: aProfile receives as parameter a name of a predefined profile. This way is handy for automation. 

**The third** one finally is to manually build your own profile, and set it up, agan by code 	
 ```smalltalk
    profile := TKTProfile new. 
	... 
	configure 
	...
 	TKTConfiguration profile: profile.
 ```

- **Defining a new predefined-profile** 
To add a new profile is pretty easy, and so far, pretty static.

To add a new profile you have only to define a new method in the class side of TKTProfile, adding the pragma 
`<profile:#profileName>`

This method should return an instance of TKTProfile, or an object polimorphic to it. 

Since some configurations may not be compatible (since the debugging mode has some specific restrictions), a check of sanity of the configuration is done during the activation of the profile. Therefore, it is expected to have exceptions with some configurations. 

- **Modifying an existing predefined-profile** 

You can modify an existing profile since everything is in the code. You just modify the method related to the selected profile. If the modified profile is active, the changes will have no effect until you activily reset this profile. You can use any of the ways of setting up the current profile for forcing the reload of the profile. 

- **Using a specific profile during specific computations**

At some point you may need to switch the working profile, or part of it, not for all the image but for some specific computation. We have defined some different methods that would allow you to achieve this feature by code. 

 ```smalltalk
 TKTConfiguration class>>
 
 profileNamed: aProfileName during: aBlock      	
 	" Uses a predefined profile, during the execution of the given block "

 profile: aProfile during: aBlock					
 	" Uses a profile, during the execution of the given block "

 errorHandler: anErrorHandler during: aBlock		
 	" Uses a given errorHandler, during the execution of the given block "

 poolWorkerProcess: anObject during: aBlock			
 	" Uses a given Pool-Worker process, during the execution of the given block "

 process: anObject during: aBlock					
 	" Uses a given process, during the execution of the given block "

 processProvider: aProcessProvider during: aBlock	
 	" Uses a given Process provider, during the execution of the given block "

 serviceManager: aManager during: aBlock			
 	" Uses a given Service manager, during the execution of the given block "
 ```

An example of usage
 ```smalltalk
 future := TKTConfiguration profileNamed: #test during: [ [2 + 2 ] future ]
 ```

## Future versions

- Better management of the profile configuration
- Inter-innerprocess debugging
- Enhancing actor's model 
- Exploring again over forking images.
