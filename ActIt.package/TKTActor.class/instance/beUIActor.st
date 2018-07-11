initialize
beUIActor
	self isUIActor
		ifTrue: [ ^ self ].
	self installRunner: TKTUIProcessTaskRunner new