tests-worker
testWorkerInstancesAreCollectedAfterStartingAndStoppingWorker
	<expectedFailure>
	self trackInstancesOf: TKTWorker during: [ TKTWorker new start stop ]