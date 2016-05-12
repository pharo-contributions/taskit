finalization
finalize
	self isValueAvailable ifFalse: [
		self cancel
	].