"
The debug runner binds the running thread with a process holder that is in charge of opening eventually a debugger. 
This flavour is specific for worker 
"
Class {
	#name : #TKTDebuggWorkerProcess,
	#superclass : #TKTWorkerProcess,
	#category : 'TaskItDebugger'
}

{ #category : #configuration }
TKTDebuggWorkerProcess class >> isDebuggingCompatible [
	^ true
]

{ #category : #schedulling }
TKTDebuggWorkerProcess >> linkThreads [
	process isTaskItRawProcess
		ifTrue: [ process
				masterProcessHolder: ((Smalltalk at: #TKTRawProcessHolder) for: Processor activeProcess) ]
]

{ #category : #schedulling }
TKTDebuggWorkerProcess >> start [
	super start.
	self linkThreads.
]
