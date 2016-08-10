private - verifications
verifyForAsync
	self
		assert: (self isCompatible and: [ job isSimpleAsync ])
		description:
			' For asking for a asynchronous result process you must ask for a #asyncTask  instead of a #loopingService or #simpleTask.'