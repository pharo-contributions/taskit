initialize
initializeWith: aTKTActorBehaviour
	self assert: model isNil.
	model := aTKTActorBehaviour.
	runner := TKTWorker new.
	runner name: ('Actor-{ID}' format: {(#ID -> UUID new)} asDictionary).
	runner queue: TKTMailBox new.
	