accessing
enable
	self isEnabled ifTrue: [ ^ self ].
	
	self register.
	TKTProcess rawProcessClass: TKTRawProcess.
	IsEnabled := true