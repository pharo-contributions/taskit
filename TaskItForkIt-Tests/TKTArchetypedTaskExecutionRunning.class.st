Class {
	#name : #TKTArchetypedTaskExecutionRunning,
	#superclass : #TestCase,
	#instVars : [
		'taskExecution',
		'taskToExecute',
		'serializer',
		'id',
		'task',
		'isAlive'
	],
	#category : #'TaskItForkIt-Tests'
}

{ #category : #tests }
TKTArchetypedTaskExecutionRunning >> futureArchetypedTask: task [
	^ #futureArchetypedTask:
]

{ #category : #running }
TKTArchetypedTaskExecutionRunning >> isAlive [
	^ isAlive
]

{ #category : #tests }
TKTArchetypedTaskExecutionRunning >> privateFuture: aTask [
	^ #privateFuture:
]

{ #category : #running }
TKTArchetypedTaskExecutionRunning >> sendTaskAndProcessResponse: aTask id: anId serializer: aSerializer [
	taskToExecute := aTask.
	serializer := aSerializer.
	id := anId.
	isAlive
		ifFalse: [ TKTRetryException signal: 'Error' ]
]

{ #category : #running }
TKTArchetypedTaskExecutionRunning >> setUp [
	super setUp.
	task := [  ] asArchetypedTaskOn: TKTArchetype pharo80.
	taskExecution := task
		configureTaskExecution: TKTRemoteTaskExecution new
		with: nil.
	taskExecution backend: self.
	taskExecution id: #something.
	isAlive := true.
]

{ #category : #tests }
TKTArchetypedTaskExecutionRunning >> testArchetypedTaskBuildsOnRunnerWithPrivateFutureMessage [
	self
		assert: (TKTArchetypedTask new future: self)
		equals: #futureArchetypedTask:
]

{ #category : #running }
TKTArchetypedTaskExecutionRunning >> testDoExecuteNonAliveBackendExplodes [
	isAlive := false.
	taskExecution doExecuteTask .
	self assert: taskExecution future isFailure. 
	self should: [ taskExecution future synchronizeTimeout: 1 second ] raise: TKTRetryException
]

{ #category : #running }
TKTArchetypedTaskExecutionRunning >> testDoExecuteUsesBackend [
	taskExecution doExecuteTask.
	self deny: taskExecution future isFinished.
	self assert: taskToExecute valuable equals: task valuable.
	self assert: id equals: taskExecution id.
	self assert: serializer equals: task serializerSelector.
	
]

{ #category : #tests }
TKTArchetypedTaskExecutionRunning >> testGenericTaskBuildsOnRunnerWithPrivateFutureMessage [
	self assert: (TKTGenericTask new future: self) equals: #privateFuture:
]

{ #category : #tests }
TKTArchetypedTaskExecutionRunning >> testGenericTaskResolvesThisImageAsArchetype [
	self assert: [  ] asTask archetype equals: TKTArchetype thisImage 
]
