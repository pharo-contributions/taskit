accessing
enable
	self isEnabled
		ifTrue: [ ^ self ].
	self register.
	TKTProcess rawProcessClass: TKTRawProcess.
	TKTWorker processClass: TKTDebuggWorkerProcess.
	IsEnabled := true