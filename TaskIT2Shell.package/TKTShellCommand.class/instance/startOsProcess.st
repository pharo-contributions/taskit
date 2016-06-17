private -execution
startOsProcess
	self initializeStreams.
	osProcess := OSProcess thisOSProcess
		forkJob: self interpreter
		arguments: (Array with: '-c' with: command)
		environment: nil
		descriptors:
			{nil.
			stdout writeStream.
			stderr writeStream}