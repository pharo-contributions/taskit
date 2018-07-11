initialize
initializeWith: aTKTActorBehaviour
	self assert: model isNil.
	actorModificationMutex := Mutex new.
	model := aTKTActorBehaviour.
	self beReadOnlyObject.
	self beWorkerActor.