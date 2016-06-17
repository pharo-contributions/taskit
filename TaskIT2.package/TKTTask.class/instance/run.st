running
run
	^ (TKTSynchronousSimpleJob forTask: self) runIn: TKTLocalProcessRunner new