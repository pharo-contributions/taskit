TaskIT2 is a processing framework that aims to bring objects to Pharo. 

#Starting by usage! 

TaskIT2 provides three ways of execution, based strictly on message send, to avoid casual references from BlockClosure contexts. 
For making easy the usage of TaskIT we had build a builder object.

## Asynchronous execution

Asynchronous execution is the basic one. Is meant for something that starts and finish, and we give callbacks for being called when the process is finished, by success or failure. 


```
   | builder |
	builder := TKTBuilder new.
	builder
		asyncTask;
		onSuccess: [ :result | result inspect ] 
                onFailure: [ :err | self inform: err messageText ];
		send: #yourself;
		to: 2;
		inALocalProcess;
		execute
```


Let's breakdown the code in pieces


First we need to create a Builder object, that will facilitate the creation and configuration of the execution
```
   | builder |
	builder := TKTBuilder new. 
```

As a second step, we ask the builder to build an asynchronous task by sending the following message 
```
    builder asyncTask.
```

This task should execute the following callbacks, in each of both following cases:
```
  builder onSuccess: [ :result | result inspect ] 
          onFailure: [ :err | self inform: err messageText ].
```
As you can see, the success call receives the result of the execution (the return of the message send) as parameter. By other hand, the failure callback receives the error it self. 


As we said in the beginning, the execution will be based on a message send. So we need this parameters to the builder. 
 In this case we will be sending #yourself to the object 2. 
```
  builder send: #yourself; to: 2
```

   TaskIT supports actually two kind of processing strategies, traditional Green thread, and same process execution. 

   In the case of our example, we do ask for an independent local process. 

```
  builder inALocalProcess
```

   Finally, we do ask the builder to execute our process by sending the execute message

```
  builder execute
```

## Synchronous execution

   The synchronous execution is based on a mechanism of futures and results, implemented on top of the asynchronous mechanism.
  The particularity of this mechanism is that the synchronisation of the calling process and the new process has place when the future result of the execution is used. 

  The following example sends #yourself to the object 2 and tries to use the result of this execution for sending a + message. 

###Futures

```
	| builder future |
	builder := TKTBuilder new.
	future := builder
		simpleTask;
		send: #yourself;
		to: 2;
		inALocalProcess;
		future.
	future inspect.
	self assert: future value + 2 = 4
```


Let's breakdown the code in pieces


First we need to create a Builder object, that will facilitate the creation and configuration of the execution
```
   | builder future |
	builder := TKTBuilder new. 
```

As a second step, we ask the builder to build an synchronous task by sending the following message 
```
    builder simpleTask.
```

As we said in the beginning, the execution will send #yourself to the object 2. . So we need to inform this parameters to the builder. 

```
  builder send: #yourself; to: 2
```

   TaskIT supports actually two kind of processing strategies, traditional Green thread, and same process execution. 

   In the case of our example, we do ask for an independent local process. 

```
  builder inALocalProcess
```

   Finally, we do ask the builder for the execution of our process and the acquisition of the future object by sending the future message

```
  builder future
```

  
### Result

  The result mechanism is not more than an extension to the futures mechanism, where the object that synchronises is not a future but a result. A result is a proxy object to the result of the execution. This case is based on the become functionality of smalltalk. This proxy will, then, become the result it self when the execution is finished. This functionality is more expensive, but, it hides the fact that the object is related to an other execution, allowing then to pass this object as parameter to other methods, giving a fine grained point of synchronisation. 

```
	| builder result |
	builder := TKTBuilder new.
	result := builder
		simpleTask;
		send: #yourself;
		to: 2;
		inALocalProcess;
		result.
	result inspect.
	self assert: result + 2 = 4
```

We will not breakdown all this code, because is the same code as the future example. The only real difference is that the building message is #result.


### Details

  In this case of processing, where the processing has meaning because someone will eventually use the result, the garbage collecting of the future or result is reason enough to cancel the execution of the process. If you don't care about the result, then you are more likely using the asynchronous approach. 


## Looping service execution 

   Finally, we have as well process that are not mean to finish, or be reduced into a result, but to provide a service. 


```
   | builder jobExecution |
	builder := TKTBuilder new.
	jobExecution := builder
		loopingService;
		onServiceFinalization: [ Transcript logCr: 'Service has finished' ]
			onFailure: [ :err | self inform: err messageText ];
		send: #spinOnce;
		to: self;
		inALocalProcess;
		start.
	1 second wait.
	jobExecution stop
```

Let's breakdown the code in pieces


First we need to create a Builder object, that will facilitate the creation and configuration of the execution
```
   | builder future |
	builder := TKTBuilder new. 
```

As a second step, we ask the builder to build a loopingService task by sending the following message 
```
    builder loopingService.
```

  Since services are susceptibles to be stopped or to crash on a failure, we can give two callbacks for these scenarios. 

```
    builder onServiceFinalization: [ Transcript logCr: 'Service has finished' ]
            onFailure: [ :err | self inform: err messageText ];
```
 
  Meanwhile the onServiceFinalization does not receive any parameter, the onFailure one receives the error it self. 

   As we said in the beginning and in the previous configurations, the execution will be based on a message send. 

```
  builder send: #spinOnce; to: self;
```

   In this specific case, the message send will be executed indefinitely, inside a loop. For this reason, we need to mind things like the rate of execution (by sleeping the process) and the inner object state. 


 In the case of our example, we do ask for an independent local process. 

```
  builder inALocalProcess
```
  Finally, for start our looping service, we need to send the magic word #start

```
  jobExecution := builder start
```

  jobExecution is an object that will allow us to control the service; being allowed to change the callbacks of the service, or cancel it execution. 

  As with the future and result mechanism, if the control object is garbage collected, the service is cancelled as well. 



