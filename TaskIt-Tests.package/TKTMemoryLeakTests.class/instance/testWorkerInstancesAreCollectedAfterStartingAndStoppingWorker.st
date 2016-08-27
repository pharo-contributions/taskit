tests-worker
testWorkerInstancesAreCollectedAfterStartingAndStoppingWorker

	self
		trackInstancesOf: TKTWorker
		during: [ TKTWorker new start stop ]