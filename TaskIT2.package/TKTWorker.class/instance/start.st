starting
start
	
	process := [ [ self executeTask: queue next ] repeat ] fork.