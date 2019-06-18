"
This worker pool is a tipical worker pool extended to use remote processes of a specifica kind. 
"
Class {
	#name : #TKTArchetypedWorkerPool,
	#superclass : #TKTCommonQueueWorkerPool,
	#instVars : [
		'archetype',
		'backends'
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
TKTArchetypedWorkerPool >> getOrCreateBackend [
	backends
		ifEmpty: [ backends
				add:
					(TKTForkedBackend new
						archetype: archetype;
						start;
						yourself) ].
	^ backends first
]

{ #category : #accessing }
TKTArchetypedWorkerPool >> initialize [
	super initialize.
	backends := OrderedCollection new
]

{ #category : #accessing }
TKTArchetypedWorkerPool >> privateNewWorker [
	| newWorker processWorker |
	processWorker := TKTForkedWorkerProcess new.
	processWorker backend: self getOrCreateBackend.
	newWorker := TKTWorker new
		name:
			self name , ' ArchetypeWorker #' , (self size + 1) asString , ' '
				, archetype name;
		taskQueue: taskQueue;
		privatePrepareProcess: processWorker;
		privateStart;
		yourself.
	workers add: newWorker.
	^ newWorker
]

{ #category : #'as yet unclassified' }
TKTArchetypedWorkerPool >> privateRemoveIdleWorkerIfNeeded [
	| removing free |
	free := self privateFreeWorkers.
	free size < ((taskQueue size + 1) * 2)
		ifTrue: [ ^ self ].
	removing := free anyOne.
	workers remove: removing.
	removing stop
]

{ #category : #'as yet unclassified' }
TKTArchetypedWorkerPool >> stop [
	super stop.
	backends do: #stop.
	backends removeAll
]

{ #category : #'as yet unclassified' }
TKTArchetypedWorkerPool >> supportsArchetyping [
	^ true
]
