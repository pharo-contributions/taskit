initialization
stepService
	self pool ifNil: [ self stop ] ifNotNil: [ :p | self watchDog: p ].
	self delay wait