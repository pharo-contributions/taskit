initialize
beWorkerActor
	| worker |
	self isWorkerActor
		ifTrue: [ ^ self ].
	worker := TKTWorker new.
	worker name: ('Actor-{ID}' format: {(#ID -> UUID new)} asDictionary).
	worker queue: TKTMailBox new.
	self installRunner: worker.
	worker start