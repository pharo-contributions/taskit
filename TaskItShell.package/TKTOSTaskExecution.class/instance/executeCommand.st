private
executeCommand
	task command createOSSubprocess
		redirectStdout;
		redirectStderr;
		runAndWaitOnExitDo: [ :process :outString :errString | 
			process isSuccess
				ifTrue: [ ^ outString ]
				ifFalse: [ Error signal: errString ] ]