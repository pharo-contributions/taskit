tests-workerpool
testWorkerPoolInstancesAreCollectedAfterStartingAndStoppingWorker

	self
		trackInstancesOf: TKTWorkerPool
		during: [ TKTWorkerPool new start stop ]