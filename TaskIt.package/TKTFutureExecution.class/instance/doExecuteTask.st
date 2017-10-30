evaluating
doExecuteTask
	[ future deploySuccess: super doExecuteTask ]
		on: Exception
		do: [ :error | future deployFailure: error freeze ]