accessing
stack
	^ interruptedProcess isTaskItRawProcess
		ifTrue: [ self filteredCombinedStack ]
		ifFalse: [ super stack ]