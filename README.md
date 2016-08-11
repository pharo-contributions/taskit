# TaskIT

Expressing and managing concurrent computations is indeed a concern of importance to develop applications that scale. A web application may want to use different processes for each of its incoming requests. Or maybe it wants to use a "thread pool" in some cases. In other case, our desktop application may want to send computations to a worker to not block the UI thread. 

Processes in Pharo are implemented as green threads scheduled by the virtual machine, without depending on the machinery of the underlying operating system. This has several consequences on the usage of concurrency we can do:

- Processes are cheap to create and to schedule. We can create as many as them as we want, and performance will only degrade is the code executed in those processes do so, what is to be expected.
- Processes provide concurrent execution but no real parallelism. Inside Pharo, it does not matter the amount of processes we use. They will be always executed in a single operating system thread, in a single operating system process.

Besides how expensive it is to create a process is an important concern to decide how we organize our application processes, a more difficult task arises when we want to synchronize such processes. For example, maybe we need to execute two processes concurrently and we want a third one to wait the completion of the first two before starting. Or maybe we need to maximize the parallelism of our application while enforcing the concurrent access to some piece of state. And all these issues require avoiding the creation of deadlocks.

TaskIT is a library that ease Process usage in Pharo. It provides abstractions to execute and synchronize concurrent tasks, and several pre-built mechanisms that are useful for many application developers. This chapter explores starts by familiarizing the reader with TaskIT's abstractions, guided by examples and code snippets. At the end, we discuss TaskIT extension points and possible customizations.

## Downloading

TODO

## Asynchronous Tasks

TaskIT's main abstraction are, as the name indicates it, tasks. A task is a unit of execution. By splitting the execution of a program in several tasks, TaskIT can run those tasks concurrently, synchronize their access to data, or order even help in ordering and synchronizing their execution.

### First Example

Launching a task is as easy as sending the message `schedule` to a block closure, as it is used in the following first code example:
```smalltalk
[ 1 + 1 ] schedule.
```
>The selector name `schedule` is chosen in purpose instead of others such as run, launch or execute. TaskIT promises you that a task will be *eventually* executed, but this is not necessarilly right away. In other words, a task is *scheduled* to be executed at some point in time in the future.

This first example is however useful to clarify the first two concept but it remains too simple. We are schedulling a task that does nothing useful, and we cannot even observe it's result (*yet*). Let's explore some other code snippets that may help us understand what's going on.

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

## Retrieving a Task's Result with Futures

In TaskIT we differentiate two different kind of tasks: some tasks are just *scheduled* for execution, they produce some side-effect and no result, some other tasks will produce (generally) a side-effect free value. When the result of a task is important for us, TaskIT provides us with a *future* object. A *future* is no other thing than an object that represents the future value of the task's execution. We can schedule a task with a future by using the `future` message on a block closure, as follows.

```smalltalk
aFuture := [ 2 + 2 ] future.
```

One way to see futures is as placeholders. When the task is finished, it deploys its result into the corresponding future. A future then provides access to its value, but since we cannot know *when* this value will be available, we cannot access it right away. Instead, futures provide an asynchronous way to access it's value by using *callbacks*. A callback is an object that will be executed when the task execution is finished.  

>In general terms, we do not want to **force** a future to retrieve his value in an asynchronous way.
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

## Task Runners: Controlling Where Tasks are executed 

Task runners are in charge of the execution of tasks. They decide if a task executes in a separate process, in the same process, or in a process that is shared by many tasks. A task runner  schedule and prioritize tasks.

Task runners contract is based on the following messages:

- **run:** It is the main message a task runner implements. It receives as argument a task to run and provides a future as result.
- **cancel** This message tells the runner to stop executing the task. It will, if possible, cancel the execution and notify all provided futures of this.
- **isRunning** This is a testing message that indicates if a task runner is currently running.
- **isTerminated** This is a testing message that indicates if a task runner has finished its execution.

TaskIT provides already several task runners for simple and common tasks. In the following subsections we will provide an overview on each of them for normal usage.

### New Process Task Runner

A one shot runner, instance of `TKTOneShotRunner`, is a task runner that is meant to run a single task in a separate Pharo process. The one shot runner will start a new process when the task is run, and so, handle the process' life cycle. A one shot runner, as it name says, is meant to be used once and be discarded. It should not be reused with several tasks.

The usage of a one shot runner is simple. We should create a new instance of it and send it the message `run:` with the task to run as a parameter. The result of that message will be a future object.

```smalltalk
runner := TKTOneShotRunner new.
future := runner run: [ (Delay forMilliseconds: 30000) wait ] asTask.
```

Since the usage of one shot runners is pretty common and straight forward, the `shootIt` method of a task is a shortcut to it.

```smalltalk
TKTTask >> shootIt
	
	^ TKTOneShotRunner new run: self
```

### Local Process Task Runner

The same process runner is a simple runner that executes a task in the caller process. This runner may come in handy to change the way a task runs in a transparent way, since it is polymorphic with the other task runners. A same process runner is reusable, since it holds no state.

```smalltalk
runner := TKTSameProcessRunner new.
future := runner run: [ (Delay forMilliseconds: 30000) wait ] asTask.
```

Additionally, sending the `value` message to a task is a shortcut to execute it with a same process runner.

```smalltalk
TKTTask >> value
	" The future is dispendable in this case, cause is executing in the same thread "
	^ TKTSameProcessRunner new run: self
```

### The Worker Runner


A persistent runner is a task runner that persists in time, executing many tasks. Persistent runners are associated to a unique Pharo process and manage its life-cycle. We can control the life-cicle of a persistent task runner with the following messages:

- **start** Starts the persistent runner and creates its associated process.
- **stop** Stops the persistent runner and kill its associated process.
- **suspend** Pauses the persistent runner. This can leave a task in the middle of an execution.
- **resume** Resumes a paused execution of the persistent runner.
- **waitToFinish** Will block the caller until the runner has finished to run.

Version 1 of TaskIT presents two flavors of persistent runners: the Looping Runner and the Worker Runner.

### The looping runner

A looping runner is a task runner that will execute the same task over and over again iteratively. This runner, instance of `TKTLoopingRunner`, is configured with the task and the amount of times it has to execute.
This looping runner will finish and kill its associated process once all its iterations are finished.

```smalltalk
runner := TKTLoopingRunner new loopTimes: 20; yourself.
value := 0.
future := runner run: [ value := value + 1 ] asTask.
```

By default, if no loopTimes are configured, the looping runner will loop infinitely. When using a looping runner, the future will hold always the last value obtained from the task execution.


```smalltalk
runner := TKTLoopingRunner new.
value := 0.
future := runner run: [ value := value + 1 ] asTask.

aSample := future value. 
1 second asDelay wait. 

self assert: future value > aSample. 
```


Note that we don't need to `start` explicitly the loop runner. It will be started automatically by the `run:` message.

#### The worker runner 


A worker is a runner instance of `TKTWorker` that has a queue of tasks to execute. The worker runner will execute its tasks sequencially, according to its queue. To add a task into a worker's queue, we can schedule the task using the `scheduleTask:` message. The `spawn` message provides with a shortcut to create and start a new worker.

```smalltalk
worker := TKTWorker spawn.
future := worker schedduleTask: [ 2+2 ] asTask.
self assert: future value = 4.
worker stop.
```

This kind of runner is mean for global system performance. By using workers, we can control the amount of alive processes and how tasks are distributed amongst them. For example, in the following example three tasks are executed in a separate process (which is the same process as it is the same worker), and we can still have a synchronousish style of programming.

```smalltalk
worker := TKTWorker spawn .
future := worker scheduleTask: [ 2+2 ] asTask.
future2 := worker scheduleTask: [ 3+3 ] asTask.
future3 := worker scheduleTask: [ 1+1 ] asTask.
self assert: (future value + future2 value + future3 value) = 12.
worker stop.
```

You can create your own worker instances as shown in the examples, or also you can use it through the `TKTTaskDispatcher` singleton worker pool.

## The Worker pool extension

A worker pool is our implementation of a threads pool. Its main purpose is to provide with several worker runners and decouple us from the management of threads/processes. Worker pools are built on top of TaskIT, inside the PoolIT package. A worker pool, instance of `PITWorkersPool`, manages several worker runners. All runners inside a worker pool shared a single task queue. We can schedule a task for execution using the `dispatch:` message.

```smalltalk
dispatcher := PITWorkersPool instance. 
future := dispatcher dispatch: [ 1+1 ] asTask.
future value = 2
```

By default, a worker pool spawns two workers during it initialization (which is lazy). We can add more workers to the pool with the `addWorker` message and remove them with the `removeWorker` message.

```smalltalk
dispatcher := PITWorkersPool instance. 
dispatcher addWorker.
dispatcher
    removeWorker;
    removeWorker
```

The `removeWorker` message send will fail if there is no workers available to remove. The removed worker will stop after it finishes any task it is running, and it will not be available for usage any more. The last remaining reference to this worker is given as return of the message.

Finally, there is a fancy way to schedule tasks into the singleton pool of workers.

```smalltalk
future := [ 2 + 2 ] scheduleIt. 
```

## Advanced Futures



# To Review

### Synchronous result retrieval

The simplest way to interact with a future is synchronously. That is, when asking for a future's value, it will block the actual process until the value is available. We can do that by sending our future the message `value`.

```smalltalk
future := [ 2 + 2 ] shootIt.
self assert: future value equals: 4.
```

However, it could have happened that the finished in an erroneous state, with an exception. In such case, the exception that was thrown inside the task's execution is forwarded to the sender of `value`.

```smalltalk
future := [ SomeError signal ] shootIt.
[ future value ] on: SomeError do: [ :error | "We handle the error" ].
```

A future can also tell us if the task is already finished or not, by sending it the message `isValueAvailable`. The `isValueAvailable` message, opposedly to the `value` message, will not block the caller's process but return immediately a boolean informing if the task has finished.

```smalltalk
future := [ 2 + 2 ] shootIt.
future isValueAvailable.
```

However, waiting synchronously or polling for the task to be finished can be a waste of CPU time sometimes. For those cases when completely synchronous execution does not fit, TaskIT provides an alternative of retrieving a value with a timeout option, using the `valueTimeoutMilliseconds:` message. When we specify a timeout, we can also provide a block to handle the timeout case using the `valueTimeoutMilliseconds:ifTimeout:`. If we choose not to provide such a block, the default behavior in case of timeout is to throw a `TKTTimeoutError` exception.

```smalltalk
future := [ (Delay forMilliseconds: 100) wait ] shootIt.

future
    valueTimeoutMilliseconds: 2
    ifTimeout: [ "if it times out we execute this block"].

future valueTimeoutMilliseconds: 2.
```

### Lazy result resolution

A third way to work with futures is to ask them for a lazy result. A lazy result is an object that represents, almost transparently, the value of the task execution. This lazy result will be (using some reflective Pharo facilities) the value of the result once it is available, or under demand (for example, when a message is sent to it). Lazy results support a style of programming that is close to the synchronous style, while performing asynchronously if the result is not used. 

```smalltalk
future := [ employee computeBaseSallary ] shootIt.
result := future asResult.

subTotal := employee sumSallaryComponents

result + subTotal
```

@@comment explain the code

Note: Lazy results are to be used with care. They use Pharo's `become:` facility, and so, it will scan the system to update object references.

Lazy results can be used to easily synchronize tasks. One task running in parallel with another one and waiting for it to finish can use a lazy result object to perform transparently as much work as it can in parallel and then get blocked waiting for the missing part. Only when the result object is sent a message the 

```smalltalk
future := [ employee computeBaseSallary ] shootIt.
baseSallary := future asResult.

[ employee sumSallaryComponents + baseSallary ] shootIt value.
```

## Customizing TaskIT

### Custom Tasks

When you need to customize a task, the most important thing is to mind the main invocation method. 
	
```smalltalk 
runOnRunner: aRunner withFuture: aFuture

	| value |
	self setUpOnRunner: aRunner withFuture: aFuture.
	[
		[
			value := self executeWithFuture: aFuture. 
		] on: Error do: [ : exception |
			^ aRunner deployError: exception intoFuture: aFuture.
		].
		aRunner deployValue: value intoFuture: aFuture.
	] ensure: [
		self tearDownOnRunner: aRunner withFuture: aFuture.
		aRunner noteFutureHasFinished: aFuture.
	].
```

The task execution life cycle is defined here. 
	
It has a setup, execution and teardown	 time that is always executed. 
In this method we also have two important parts the deploy of the result (success or error) and the notification of a future as finished. (The future window is not just the task running, it is all the task execution life time. From the setup to the teardown).

So, if you need a task to setUp resources, or have some cleanup post processing, in the same process line, do not hesitate in subclassing and using this prepared hooks.  

```smalltalk
TKTSubClassedTask>>#setUpOnRunner: aRunner withFuture: aFuture.
TKTSubClassedTask>>#tearDownOnRunner: aRunner withFuture: aFuture.
```

By other side, if what you need is to change the execution it self (Maybe the main invocation method is not really suitable for you), remember always to notice the runner about the finishing of an execution, by sending the proper notification inside your overridden method.

```smalltalk
TKTSubClassedTask>>#runOnRunner: aRunner withFuture: aFuture
	"..."
	aRunner noteFutureHasFinished: aFuture.
	"..."
```
### Custom Task Runners

## Conclusion
	
In this chapter we present TaskIT framework for dealing with common concurrent architecture problems. We covered how to start a create a task from a block, how does that task run into a runner. We covered also futures as way to obtain a value, and to have a gate to synchronise your threads explicitly, and covered lazy results for synchronising your threads implicitly.

Finally we explain also how TaskIT deal with thread pools, explaining how to use it, and the impact in the global system performance.  


%!!ActIT: A Simple Actor Library on top of TaskIT



%!!TODOs

%- Discuss with Santi: What should be a good behavior if an error occurrs during a callback?
%- Does it make sense to put callbacks on a task (besides or instead putting it on the future)?
%- What about implementing lazy results with proxies (and do just forwarding?)?
%- ExclusiveVariable finalize is necesary?
%- Lazy result can be cancelled?
%- interruptCurrentTask

%	currentTask ifNotNil: [ 
%		currentTask value isProcessFinished ifFalse: [
%			currentTask  priority: 10.
%			workQueue do: currentTask.
%		].
%	].
%- cleanup wtF?
%- por que hay que ejecutar esto en un task?
%self scheduleTask: [ keepRunning set: false ] asTask.


% Local Variables:
% eval: (flyspell-mode -1)
% End: