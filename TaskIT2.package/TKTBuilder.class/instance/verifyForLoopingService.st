private - verifications
verifyForLoopingService
	self
		assert: (self isCompatible and: [ job isService ])
		description:
			' For asking for a looping service process you must ask running it in a different process, but ''thisprocess'''