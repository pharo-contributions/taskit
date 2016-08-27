helpers
trackInstancesOf: aClass during: aBlock

	| before |
	before := aClass allInstances size.
	
	aBlock value.
	
	3 timesRepeat: [
		Smalltalk garbageCollect.
		50 milliSeconds wait ].
	
	self assert: before equals: aClass allInstances size.