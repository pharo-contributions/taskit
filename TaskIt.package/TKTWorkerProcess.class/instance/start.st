start-stop
start
	process := TKTConfiguration processProvider
		createProcessDoing: [ [ self executeTask: taskQueue next ] repeat ]
		named: name