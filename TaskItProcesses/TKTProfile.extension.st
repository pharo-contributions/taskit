Extension { #name : #TKTProfile }

{ #category : #'*TaskItProcesses' }
TKTProfile class >> development [
	<profile: #development>
	^ TKTProfile
		on:
			{(#debugging -> true).
			(#runner -> TKTCommonQueueWorkerPool createDefault).
			(#poolWorkerProcess -> TKTDebuggWorkerProcess).
			(#process -> TKTRawProcess).
			(#watchDog -> TKTWatchDog onDuty).
			(#errorHandler -> TKTDebuggerExceptionHandler).
			(#processProvider -> TKTTaskItProcessProvider new).
			(#serviceManager -> TKTServiceManager new)} asDictionary
]

{ #category : #'*TaskItProcesses' }
TKTProfile class >> lightweight [
	<profile: #lightweight>
	^ TKTProfile
		on:
			{(#debugging -> false).
			(#runner -> TKTWorker createDefault ).
			(#poolWorkerProcess -> TKTWorkerProcess).
			(#process -> Process).
			(#errorHandler -> TKTExceptionHandler).
			(#watchDog -> TKTWatchDog onDuty).
			(#processProvider -> TKTTaskItProcessProvider new).
			(#serviceManager -> TKTServiceManager new)} asDictionary
]

{ #category : #'*TaskItProcesses' }
TKTProfile class >> test [
	<profile: #test>
	^ TKTProfile
		on:
			{(#debugging -> false).
			(#runner -> TKTCommonQueueWorkerPool createDefault).
			(#poolWorkerProcess -> TKTWorkerProcess).
			(#process -> Process).
			(#errorHandler -> TKTExceptionHandler).
			(#watchDog -> TKTWatchDog onDuty).
			(#processProvider -> TKTTaskItProcessProvider new).
			(#serviceManager -> TKTServiceManager new)} asDictionary
]
