starting
start
	process := TKTConfiguration poolWorkerProcess new
		taskQueue: queue;
		name: name;
		yourself.
	exceptionHandler ifNotNil: [ process exceptionHandler: exceptionHandler ].
	process start