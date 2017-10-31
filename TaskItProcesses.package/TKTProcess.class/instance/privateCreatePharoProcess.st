private
privateCreatePharoProcess
	^ process := TKTConfiguration process
		forContext: self createContext
		priority: self spawnPriority