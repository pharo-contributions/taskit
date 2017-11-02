initialization
initialize
	super initialize.
	self name: ('Worker-{ID}' format: {(#ID -> UUID new)} asDictionary).
	WeakRegistry default add: self