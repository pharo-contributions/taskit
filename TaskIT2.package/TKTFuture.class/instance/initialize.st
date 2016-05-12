initialization
initialize
	super initialize.
	isDeployed := false.
	value := nil.
	error := nil.
	semaphore := Semaphore new.
	