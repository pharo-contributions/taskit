"
This worker pool is a tipical worker pool extended to use remote processes of a specifica kind. 
"
Class {
	#name : #TKTArchetypedWorkerPool,
	#superclass : #TKTCommonQueueWorkerPool,
	#instVars : [
		'archetype'
	],
	#category : #'TaskItForkIt-Worker'
}

{ #category : #'as yet unclassified' }
TKTArchetypedWorkerPool class >> createFor: anArchetype [
	^ self new
		name: 'ArchetypedPool-' , UUID new asString;
		archetype: anArchetype;
		poolMaxSize: 2;
		yourself
]

{ #category : #accessing }
TKTArchetypedWorkerPool >> archetype: aTKTArchetype [ 
	archetype := aTKTArchetype
]

{ #category : #accessing }
TKTArchetypedWorkerPool >> privateNewWorker [
	| newWorker |
	newWorker := workers
		add:
			(TKTWorker new
				name:
					self name , ' ArchetypeWorker #' , (self size + 1) asString , ' '
						, archetype name;
				taskQueue: taskQueue;
				yourself).
	TKTConfiguration
		poolWorkerProcess:
			(TKTForkedWorkerProcess new
				archetype: archetype;
				yourself)
		during: [ newWorker start ].
		
		self halt.
	^ newWorker
]

{ #category : #'as yet unclassified' }
TKTArchetypedWorkerPool >> supportsArchetyping [
	^ true
]
