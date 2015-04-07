as yet unclassified
setUp
	super setUp.
	flag := false.
	task := TKTUnit executing: [ flag := true ].
	job := TKTSimpleJob on: task