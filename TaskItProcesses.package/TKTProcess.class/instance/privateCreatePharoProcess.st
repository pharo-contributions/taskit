private
privateCreatePharoProcess
	^ process := self class rawProcessClass
		forContext: self createContext
		priority: self spawnPriority