Class {
	#name : #TKTSimpleQueueBasedWatchdog,
	#superclass : #TKTService,
	#instVars : [
		'numberOfInstances',
		'connection',
		'instances',
		'vmPath',
		'imagePath',
		'workingDir',
		'stampConnection',
		'configuration'
	],
	#category : #'TaskIt-QueueBackend-watchdog'
}

{ #category : #'instance-creation' }
TKTSimpleQueueBasedWatchdog class >> startForInstances: number [ 

	^ self startForInstances: number vmPath: nil imagePath: nil
]

{ #category : #'instance-creation' }
TKTSimpleQueueBasedWatchdog class >> startForInstances: number vmPath: aPath imagePath: imagePath [

	^ self
		startForInstances: number
		vmPath: aPath
		imagePath: imagePath
		workingDirectory: nil
]

{ #category : #'instance-creation' }
TKTSimpleQueueBasedWatchdog class >> startForInstances: number vmPath: aPath imagePath: imagePath workingDirectory: workingDir [

	^ self new 
		numberOfInstances: number;
		vmPath: aPath;
		imagePath: imagePath;
		workingDir: workingDir;
		start;
		yourself.
]

{ #category : #stepping }
TKTSimpleQueueBasedWatchdog >> checkHeartbeats [.

	stampConnection timeout: 1 "second".
	[self processHeartbeat: stampConnection readMessage] 
		on: ConnectionTimedOut do: ["Nothing we want to timeout"] .
]

{ #category : #accessing }
TKTSimpleQueueBasedWatchdog >> connection [
	^ connection
]

{ #category : #accessing }
TKTSimpleQueueBasedWatchdog >> connection: anObject [
	connection := anObject
]

{ #category : #stepping }
TKTSimpleQueueBasedWatchdog >> imagePath [

	^ imagePath ifNil: [ Smalltalk vm imagePath ]
]

{ #category : #accessing }
TKTSimpleQueueBasedWatchdog >> imagePath: anObject [
	imagePath := anObject
]

{ #category : #accessing }
TKTSimpleQueueBasedWatchdog >> initialize [

	super initialize.
	instances := OrderedCollection new.
	stampConnection := StampClient new.
	configuration := TKTQueueConfiguration default.
	
	configuration configureConnection: stampConnection.
]

{ #category : #accessing }
TKTSimpleQueueBasedWatchdog >> instances [
	^ instances
]

{ #category : #accessing }
TKTSimpleQueueBasedWatchdog >> instances: anObject [
	instances := anObject
]

{ #category : #accessing }
TKTSimpleQueueBasedWatchdog >> name [ 

	^ 'TKTSimpleWatchdog'
]

{ #category : #accessing }
TKTSimpleQueueBasedWatchdog >> numberOfInstances [
	^ numberOfInstances
]

{ #category : #accessing }
TKTSimpleQueueBasedWatchdog >> numberOfInstances: anInteger [ 
	numberOfInstances := anInteger
]

{ #category : #stepping }
TKTSimpleQueueBasedWatchdog >> processHeartbeat: msg [ 

	| heartbeat inst |

	heartbeat := FLMaterializer materializeFromByteArray: msg body.
	inst := instances detect: [ :e | e pid = heartbeat pid ] ifNone: [^self] .
	inst lastHeartbeat: heartbeat time
]

{ #category : #stepping }
TKTSimpleQueueBasedWatchdog >> purgeTerminatedInstances [

	instances := instances select: [ :e | e isRunning ]
]

{ #category : #stepping }
TKTSimpleQueueBasedWatchdog >> setUp [

	stampConnection open.
	stampConnection subscribeTo: configuration heartbeatQueueName.
	
]

{ #category : #stepping }
TKTSimpleQueueBasedWatchdog >> startMissingInstances [	

	| missingInstances |
	missingInstances := numberOfInstances - instances size.

	missingInstances timesRepeat: [  
		self startNewInstance	
	].
]

{ #category : #stepping }
TKTSimpleQueueBasedWatchdog >> startNewInstance [	

	| process inst |
	
	process := OSWSWinProcess new.
	process 	
		command: self vmPath;
		arguments: { '--headless'. self imagePath. 'eval'. '"TKTSlaveRunner startBlocking"'};
		workingDirectory: self workingDir;
		run.
		
	inst := TKTMonitoredInstance new.
	inst process: process.
	inst lastHeartbeat: Time new.
		
	instances add: inst.
	
	

]

{ #category : #stepping }
TKTSimpleQueueBasedWatchdog >> stepService [

	self validateInstances.
	20 seconds wait.
]

{ #category : #stepping }
TKTSimpleQueueBasedWatchdog >> tearDown [ 

	stampConnection close.
	instances do: [ :anInstance | anInstance terminate ]
]

{ #category : #stepping }
TKTSimpleQueueBasedWatchdog >> validateInstances [

	self checkHeartbeats.
		
	self purgeTerminatedInstances.
	self startMissingInstances	

]

{ #category : #stepping }
TKTSimpleQueueBasedWatchdog >> vmPath [

	^ vmPath ifNil: [ Smalltalk vm fileName ]
]

{ #category : #accessing }
TKTSimpleQueueBasedWatchdog >> vmPath: anObject [
	vmPath := anObject
]

{ #category : #stepping }
TKTSimpleQueueBasedWatchdog >> workingDir [

	^ workingDir ifNil: [ Smalltalk imageDirectory fullName ]
]

{ #category : #accessing }
TKTSimpleQueueBasedWatchdog >> workingDir: anObject [
	workingDir := anObject
]
