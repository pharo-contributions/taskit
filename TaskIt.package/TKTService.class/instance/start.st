starting
start
	stopRequested := false.
	TKTConfiguration serviceManager startService: self.
	