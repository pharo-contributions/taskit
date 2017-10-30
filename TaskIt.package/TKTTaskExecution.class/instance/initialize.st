initialization
initialize
	super initialize.
	state := TKTReadyTaskState new.
	setup := OrderedCollection new.
	teardown := OrderedCollection new