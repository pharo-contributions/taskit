tests-worker
testWorkerInstancesAreCollectedAfterStartingAndStoppingWorkerPool
<expectedFailure>
	self
		trackInstancesOf: TKTWorker
		during: [ TKTWorkerPool new start stop ]