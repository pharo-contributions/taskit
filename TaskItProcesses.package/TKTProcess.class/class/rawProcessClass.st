accessing
rawProcessClass
	^ RawProcessClass ifNil: [
		RawProcessClass := Process ]