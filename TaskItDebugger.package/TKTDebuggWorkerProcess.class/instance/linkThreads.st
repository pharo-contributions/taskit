schedulling
linkThreads
	process isTaskItRawProcess
		ifTrue: [ process
				masterProcessHolder: ((Smalltalk at: #TKTRawProcessHolder) for: Processor activeProcess) ]