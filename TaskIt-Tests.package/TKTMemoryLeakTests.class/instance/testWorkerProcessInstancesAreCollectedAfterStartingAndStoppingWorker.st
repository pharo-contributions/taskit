tests-workerprocess
testWorkerProcessInstancesAreCollectedAfterStartingAndStoppingWorker

	self
		trackInstancesOf: TKTWorkerProcess
		during: [ TKTWorker new start stop ]