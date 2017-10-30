accessing
disable
	self isEnabled
		ifFalse: [ ^ self ].
	IsEnabled := false.
	self unregister.
	TKTProcess rawProcessClass: nil.
	TKTWorker processClass: nil