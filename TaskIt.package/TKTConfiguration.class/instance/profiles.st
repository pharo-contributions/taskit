accessing
profiles
	^ {(#profile -> #development).
	(#development
		-> [ {(#initialize
				-> [ TKTDebugger enable.
					self class runner start ]).
			(#runner -> TKTCommonQueueWorkerPool createDefault).
			(#poolWorkerProcess -> TKTDebuggWorkerProcess).
			(#process -> TKTRawProcess).
			(#errorHandler -> TKTDebuggerExceptionHandler).
			(#processProvider -> TKTTaskItProcessProvider new).
			(#serviceManager -> TKTServiceManager new)} asDictionary ]).
	(#production
		-> [ {(#initialize
				-> [ TKTDebugger disable.
					self class runner start ]).
			(#runner -> TKTCommonQueueWorkerPool createDefault).
			(#poolWorkerProcess -> TKTWorkerProcess).
			(#process -> TKTRawProcess).
			(#errorHandler -> TKTExceptionHandler).
			(#processProvider -> TKTPharoProcessProvider new).
			(#serviceManager -> TKTServiceManager new)} asDictionary ]).
	(#test
		-> [ {(#initialize
				-> [ TKTDebugger disable.
					self class runner start ]).
			(#runner -> TKTCommonQueueWorkerPool createDefault).
			(#poolWorkerProcess -> TKTWorkerProcess).
			(#process -> TKTRawProcess).
			(#errorHandler -> TKTExceptionHandler).
			(#processProvider -> TKTTaskItProcessProvider new).
			(#serviceManager -> TKTServiceManager new)} asDictionary ])} asDictionary