initialization
initialize
	super initialize.
	process := self class processClass new
		taskQueue: queue;
		yourself.
	self name: ('Worker-{ID}' format: {(#ID -> UUID new)} asDictionary).
	WeakRegistry default add: self