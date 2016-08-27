tests-worker
testWorkerPoolInstancesAreCollectedAfterStartingAndStoppingService

	self
		trackInstancesOf: TKTWorkerPool
		during: [ TKTParameterizableService new name: 'test'; start; stop  ]