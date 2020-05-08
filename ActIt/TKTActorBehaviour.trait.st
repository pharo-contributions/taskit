Trait {
	#name : #TKTActorBehaviour,
	#instVars : [
		'aself'
	],
	#category : #'ActIt-Kernel'
}

{ #category : #accessing }
TKTActorBehaviour >> actor [
	^ self getOrCreateActor
		beWorkerActor;
		yourself
]

{ #category : #accessing }
TKTActorBehaviour >> getOrCreateActor [
	^ aself
		ifNil: [ aself := TKTActor new
				initializeWith: self;
				yourself ]
]

{ #category : #accessing }
TKTActorBehaviour >> localActor [
	^ self getOrCreateActor 
		beLocalThreadActor;
		yourself
]

{ #category : #accessing }
TKTActorBehaviour >> uiactor [
	^ self getOrCreateActor
		beUIActor;
		yourself
]
