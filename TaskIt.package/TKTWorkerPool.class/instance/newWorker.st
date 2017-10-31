schedulling
newWorker	
	^ workers add: (TKTConfiguration poolWorkerProcess new
		name: self name, ' Worker #', (self size + 1) asString;
		start)