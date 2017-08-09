as yet unclassified
testTaskExecutionReturnsStdOutputAsResult
	" command: aSymbol options: anArrayOfOptions arguments: anArrayArguments"

	|  future  value |
	future := [ :spec | spec ls argument: '/'  ] asOSTask future.
	value := (future synchronizeTimeout: 1 second) lines.
	self assert: value  size > 1 description: ' expected at least one line as result of LS '. 
	self assert: (value includes: 'home') description: ' ls in / in unix based system should include home '.