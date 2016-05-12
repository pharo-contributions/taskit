convenience
runAsLoopingService
	^ (TKTLoopingServiceJob forTask: self) runIn: TKTLocalProcessRunner new