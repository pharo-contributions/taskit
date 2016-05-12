as yet unclassified
setUp
	super setUp.
	runner := TKTLocalProcessRunner new.
	job := TKTLoopingServiceJob forTask: (TKTTask receiver: TKTDummyTestObject new selector: #spinOnce).
	callbackOnServiceFinalization := Object.
	callbackOnFailure := Object.
	