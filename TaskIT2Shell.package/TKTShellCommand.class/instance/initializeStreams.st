initialization
initializeStreams
	stdout
		ifNil: [ stdout := ('/tmp/stdout' , self hash asString) asFileReference
				openWritable: true;
				yourself ].
	stderr
		ifNil: [ stderr := ('/tmp/stderr' , self hash asString) asFileReference
				openWritable: true;
				yourself ]