initialize
isWorkerActor
	^ runner ifNil: [ false ] ifNotNil: [ runner isWorker ]