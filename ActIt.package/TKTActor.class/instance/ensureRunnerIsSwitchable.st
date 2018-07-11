initialize
ensureRunnerIsSwitchable
	self assert: (self mailbox isNil or: [ self mailbox isEmpty ])