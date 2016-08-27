tests-workerprocess
testWorkerProcessInstancesAreCollectedAfterStartingAndStoppingWorkerPool

	self
		trackInstancesOf: TKTWorkerProcess
		during: [ TKTWorkerPool new start stop ]