Class {
	#name : #TKTForkedWorkerProcess,
	#superclass : #TKTWorkerProcess,
	#instVars : [
		'deploy',
		'url'
	],
	#category : #'TaskItForkIt-Worker'
}

{ #category : #accessing }
TKTForkedWorkerProcess >> archetype: aTKTArchetype [  
	deploy := (aTKTArchetype + TKTProject worker) deploy.
	
]

{ #category : #accessing }
TKTForkedWorkerProcess >> isAlive [
	^ ZnEasy get: url / #alive
]

{ #category : #accessing }
TKTForkedWorkerProcess >> isFree [
	^ ZnEasy get: url / #isFree
]

{ #category : #accessing }
TKTForkedWorkerProcess >> isRunning [
	
	^	self isAlive
]

{ #category : #'instance creation' }
TKTForkedWorkerProcess >> new [
	" Polymorphic hook"

	^ self
]

{ #category : #accessing }
TKTForkedWorkerProcess >> sendTaskAndProcessResponse: aTask [
	| response |
	response := ZnEasy
		post: url / #task
		data:
			(String streamContents: [ :str | (STONWriter on: str) nextPut: aTask ]).
	response := (STONReader on: response entity string readStream) next.
	(response at: #isError)
		ifTrue: [ ^ self error: (response at: #result) ].
	^ response at: #result
]

{ #category : #accessing }
TKTForkedWorkerProcess >> start [
	url := deploy evalSerialized: ' TKTWorkerService startUp '.
	self assert: self isAlive
]

{ #category : #accessing }
TKTForkedWorkerProcess >> stop [
	^ ZnEasy get: url / #stop
]
