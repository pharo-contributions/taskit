private
privateCreatePharoProcess
	^ process := Process forContext: self createContext priority: self spawnPriority