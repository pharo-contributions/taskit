starting
restart
	self stop.
	0.5 second wait.
	stopRequested := false.
	stopCallbacks := Set new.
	self start