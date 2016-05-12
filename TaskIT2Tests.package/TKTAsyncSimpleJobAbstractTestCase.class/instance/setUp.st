as yet unclassified
setUp
	super setUp.
	runner := TKTLocalProcessRunner new.
	job := TKTAsynchronousSimpleJob forTask: self createTestingTask