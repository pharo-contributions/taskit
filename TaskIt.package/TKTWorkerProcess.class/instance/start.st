start-stop
start
	process := TKTConfiguration processProvider
		createProcessDoing: (MessageSend receiver: self selector: #workerLoop)
		named: name