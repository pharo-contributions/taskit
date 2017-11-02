starting
start
	process := TKTConfiguration poolWorkerProcess new
		taskQueue: queue;
		name: name;
		yourself.
	process start