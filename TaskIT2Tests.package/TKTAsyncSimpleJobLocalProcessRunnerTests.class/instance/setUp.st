running
setUp
	super setUp.
	job := TKTAsynchronousSimpleJob forTask: (TKTTask receiver: TKTDummyTestObject new selector: #dummyMessage).
	