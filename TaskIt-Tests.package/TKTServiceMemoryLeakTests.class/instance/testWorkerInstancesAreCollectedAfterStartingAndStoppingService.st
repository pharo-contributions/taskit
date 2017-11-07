tests-worker
testWorkerInstancesAreCollectedAfterStartingAndStoppingService
	<expectedFailure>
	self
		trackInstancesOf: TKTWorker
		during: [ TKTParameterizableService new
				name: 'test';
				start;
				stop ]