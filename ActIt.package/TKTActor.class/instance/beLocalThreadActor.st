initialize
beLocalThreadActor
	self isLocalThreadActor
		ifTrue: [ ^ self ].
	self installRunner: TKTLocalProcessTaskRunner new