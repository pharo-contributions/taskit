initialization
initialize
	super initialize.
	self step: [ 100 milliSeconds wait ].
	self stepDelay: 1 second