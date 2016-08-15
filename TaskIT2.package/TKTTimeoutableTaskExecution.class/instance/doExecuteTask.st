evaluating
doExecuteTask

	TKTProcessProvider createProcessDoing: [
		timeout wait.
		self isFinished ifFalse: [ self cancel ]].
	super doExecuteTask.