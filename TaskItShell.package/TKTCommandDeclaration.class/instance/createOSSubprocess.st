building
createOSSubprocess
	^ OSSUnixSubprocess new
		command: self commandPath;
		arguments: (options , arguments) asArray;
		yourself