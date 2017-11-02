accessing
profiles
	^ {(#profile -> #development).
	(#development
		-> [ {(#initialize
				-> [ TKTDebugger enable.
					TKTCommonQueueWorkerPool startGlobal ]).
			(#runner -> TKTCommonQueueWorkerPool global).
			(#poolWorkerProcess -> TKTDebuggWorkerProcess).
			(#process -> TKTRawProcess).
			(#errorHandler -> TKTDebuggerExceptionHandler).
			(#processProvider -> TKTTaskItProcessProvider new).
			(#serviceManager -> TKTServiceManager new)} asDictionary ]).
	(#production
		-> [ {(#initialize
				-> [ TKTDebugger disable.
					TKTCommonQueueWorkerPool startGlobal ]).
			(#runner -> TKTCommonQueueWorkerPool global).
			(#poolWorkerProcess -> TKTWorkerProcess).
			(#process -> TKTRawProcess).
			(#errorHandler -> TKTExceptionHandler).
			(#processProvider -> TKTPharoProcessProvider new).
			(#serviceManager -> TKTServiceManager new)} asDictionary ]).
	(#test
		-> [ {(#initialize
				-> [ TKTDebugger disable.
					TKTCommonQueueWorkerPool startGlobal ]).
			(#runner -> TKTCommonQueueWorkerPool global).
			(#poolWorkerProcess -> TKTWorkerProcess).
			(#process -> TKTRawProcess).
			(#errorHandler -> TKTExceptionHandler).
			(#processProvider -> TKTTaskItProcessProvider new).
			(#serviceManager -> TKTServiceManager new)} asDictionary ])} asDictionary