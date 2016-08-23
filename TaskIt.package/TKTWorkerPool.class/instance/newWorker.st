schedulling
newWorker
	
	^ TKTWorker new
		name: 'Global Pool Worker #', (self size + 1) asString;
		start