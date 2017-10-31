accessing
profiles
	^ {(#profile -> #development).
	(#development
		-> [ {(#initialize -> [ TKTDebugger enable ]).
			(#runner -> TKTWorkerPool global).
			(#poolWorkerProcess -> TKTDebuggWorkerProcess).
			(#process -> TKTRawProcess).
			(#errorHandler -> TKTDebuggerExceptionHandler).
			(#processProvider -> TKTTaskItProcessProvider new).
			(#serviceManager -> TKTServiceManager)} asDictionary ]).
	(#production
		-> [ {(#initialize -> [ TKTDebugger disable ]).
			(#runner -> TKTWorkerPool global).
			(#poolWorkerProcess -> TKTWorkerProcess).
			(#process -> TKTRawProcess).
			(#errorHandler -> TKTExceptionHandler).
			(#processProvider -> TKTPharoProcessProvider new).
			(#serviceManager -> TKTServiceManager)} asDictionary ]).
	(#test
		-> [ {(#initialize -> [ TKTDebugger disable ]).
			(#runner -> TKTWorkerPool global).
			(#poolWorkerProcess -> TKTWorkerProcess).
			(#process -> TKTRawProcess).
			(#errorHandler -> TKTExceptionHandler).
			(#processProvider -> TKTTaskItProcessProvider new).
			(#serviceManager -> TKTServiceManager)} asDictionary ])} asDictionary