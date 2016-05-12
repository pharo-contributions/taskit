private - verifications
verifyForResult
	self
		assert: (self isCompatible and: [ job isSimpleSync ])
		description: ' For asking for a result you must ask for a #simpleTask  instead of a #loopingService.'