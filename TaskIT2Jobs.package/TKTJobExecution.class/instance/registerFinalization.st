accessing
registerFinalization
	self
		toFinalizeSend: #finalizeExecution:
		to: job
		with:
			{taskExecution.
			runner}.
	^ self