initialization
finalize
	self
		schedule: [ | theProcess |
			queue := nil.
			theProcess := process.
			theProcess ifNotNil: [ theProcess kill ].
			process := nil ]