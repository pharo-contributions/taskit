running
setUp
	super setUp.
	receiver := TKTDummyTestObject new.
	job := TKTAsynchronousSimpleJob forTask: (TKTTask receiver: receiver selector: #dummyMessageWithParameter:).
