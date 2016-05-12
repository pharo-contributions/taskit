as yet unclassified
setUp
	super setUp.
	runner := TKTLocalProcessRunner new.
	receiver := TKTDummyTestObject new.
	job := TKTLoopingServiceJob forTask: (TKTTask receiver: receiver selector: #spinOnceWithParam:).
	callbackOnServiceFinalization := Object.
	callbackOnFailure := Object