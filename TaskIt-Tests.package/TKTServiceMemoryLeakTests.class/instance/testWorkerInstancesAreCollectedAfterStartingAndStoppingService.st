tests-worker
testWorkerInstancesAreCollectedAfterStartingAndStoppingService

	self
		trackInstancesOf: TKTWorker
		during: [ TKTParameterizableService new
				name: 'test';
				start;
				stop ]