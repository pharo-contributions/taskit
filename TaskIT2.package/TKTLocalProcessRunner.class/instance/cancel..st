editing keys
cancel: aTKTTaskExecution
	process ifNil: [ ^ self ].
	process
		ifRunning: [ 
			(process isRelatedWith: aTKTTaskExecution)
				ifTrue: [ process cancel ] ]