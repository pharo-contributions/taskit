building
createOSSubprocess
	^ OSSUnixSubprocess new
		workingDirectory: self workingDirectory;
		command: self commandPath;
		arguments: (options , arguments) asArray;
		yourself