private -execution
privateExecute
	hasBeenExecuted
		ifTrue: [ self error: 'This command is alread in use' ]
		ifFalse: [ hasBeenExecuted := true.
			self startOsProcess ]