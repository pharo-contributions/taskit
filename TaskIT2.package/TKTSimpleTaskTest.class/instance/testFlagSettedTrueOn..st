as yet unclassified
testFlagSettedTrueOn: aRunner
	self deny: flag.
	self assert: (self reduceRunningIn: aRunner).
	self assert: flag