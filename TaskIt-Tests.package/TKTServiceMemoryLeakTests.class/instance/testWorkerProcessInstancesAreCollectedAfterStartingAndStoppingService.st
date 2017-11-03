tests-worker
testWorkerProcessInstancesAreCollectedAfterStartingAndStoppingService

	self
		trackInstancesOf: TKTWorkerProcess
		during: [ TKTParameterizableService new name: 'test'; start; stop  ]