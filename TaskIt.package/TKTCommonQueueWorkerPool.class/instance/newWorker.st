schedulling
newWorker	
	^ workers add: (TKTWorker new
		name: self name, ' Worker #', (self size + 1) asString;
		taskQueue: taskQueue;
		start)