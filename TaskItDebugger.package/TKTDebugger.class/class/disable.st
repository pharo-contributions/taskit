accessing
disable
	self isEnabled
		ifFalse: [ ^ self ].
	IsEnabled := false.
	self unregister.