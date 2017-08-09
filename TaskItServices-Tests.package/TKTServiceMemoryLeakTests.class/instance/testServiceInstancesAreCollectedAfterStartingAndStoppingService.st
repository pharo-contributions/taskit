tests-worker
testServiceInstancesAreCollectedAfterStartingAndStoppingService

	self
		trackInstancesOf: TKTParameterizableService
		during: [ TKTParameterizableService new name: 'test'; start; stop  ]