private
executeCommand
	task command createOSSubprocess
		runAndWaitOnExitDo: [ :process :outString :errString | 
			process isSuccess
				ifTrue: [ ^ outString ]
				ifFalse: [ Error signal: errString ] ]