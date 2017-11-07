tests-worker
testWorkerInstancesAreCollectedAfterStartingAndStoppingWorkerPool

	self
		trackInstancesOf: TKTWorker
		during: [ TKTWorkerPool new start stop ]