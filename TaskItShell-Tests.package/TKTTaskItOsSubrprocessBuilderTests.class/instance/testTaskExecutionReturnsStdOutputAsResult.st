as yet unclassified
testTaskExecutionReturnsStdOutputAsResult
	" command: aSymbol options: anArrayOfOptions arguments: anArrayArguments"

	|  future  value |
	future := [ :spec | spec ls argument: '/'  ] asOSTask future.
	value := (future synchronizeTimeout: 1 second) lines.
	self assert: value  size > 1. 
	self assert: (value includes: 'home').