initialization
finalize
	self
		schedule: [ | theProcess |
			queue := nil.
			theProcess := process.
			theProcess kill.
			process := nil ]