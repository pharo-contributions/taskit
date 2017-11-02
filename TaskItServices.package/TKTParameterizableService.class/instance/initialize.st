initialization
initialize
	self halt.
	super initialize.
	self step: [ 100 milliSeconds wait ]