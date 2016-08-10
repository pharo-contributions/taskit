private - verifications
verifyForFuture
	self
		assert: (self isCompatible and: [ job isSimpleSync  ])
		description: ' For asking for a future you must ask for a #simpleTask  instead of a #loopingService.'