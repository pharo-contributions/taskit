convenience
run
	^ (TKTSynchronousSimpleJob forTask: self) runIn: TKTLocalProcessRunner new