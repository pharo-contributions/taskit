"
The debug runner binds the running thread with a process holder that is in charge of opening eventually a debugger. 
This flavour is specific for use/disposal one process runner 
"
Class {
	#name : #TKTNewProcessDebugTaskRunner,
	#superclass : #TKTRunner,
	#category : 'TaskItDebugger'
}

{ #category : #schedulling }
TKTNewProcessDebugTaskRunner >> executeTask: aTaskExecution [
	self linkThreadsFor: aTaskExecution.
	super executeTask: aTaskExecution
]

{ #category : #schedulling }
TKTNewProcessDebugTaskRunner >> linkThreadsFor: aTaskExecution [
	| executionProcess |
	executionProcess := aTaskExecution executionProcess.
	executionProcess isTaskItRawProcess
		ifTrue: [ executionProcess masterProcessHolder: ((Smalltalk at: #TKTRawProcessHolder) for: Processor activeProcess) ]
]

{ #category : #schedulling }
TKTNewProcessDebugTaskRunner >> scheduleTaskExecution: aTaskExecution [
	TKTConfiguration processProvider
		createProcessDoing: (MessageSend receiver: self selector: #executeTask: arguments: {aTaskExecution})
]
