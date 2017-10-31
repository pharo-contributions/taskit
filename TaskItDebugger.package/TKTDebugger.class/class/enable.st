accessing
enable
	self isEnabled
		ifTrue: [ ^ self ].
	self register.
	IsEnabled := true