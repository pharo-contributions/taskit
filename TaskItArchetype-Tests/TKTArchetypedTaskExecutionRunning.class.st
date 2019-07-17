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
	#category : #'TaskItArchetype-Tests'
}

{ #category : #running }
TKTArchetypedTaskExecutionRunning >> isAlive [
	^ isAlive
]

{ #category : #running }
TKTArchetypedTaskExecutionRunning >> sendTaskAndProcessResponse: aTask id: anId serializer: aSerializer [
	taskToExecute := aTask.
	serializer := aSerializer.
	id := anId
]

{ #category : #running }
TKTArchetypedTaskExecutionRunning >> setUp [
	super setUp.
	task := [  ] asArchetypedTaskOn: TKTArchetype pharo80.
	taskExecution := task
		configureTaskExecution: TKTArchetypedTaskExecution new
		with: nil.
	taskExecution backend: self.
	taskExecution id: #something.
	isAlive := true.
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
