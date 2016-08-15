evaluating
value

	[ executionProcess := Processor activeProcess.
	TKTCurrentTaskRunner value: runner during: [ self doExecuteTask ]
		] ensure: [ finished := true ]