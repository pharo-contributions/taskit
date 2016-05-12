initialization
initialize
	super initialize.
	successCallbacks := OrderedCollection new.
	failureCallbacks := OrderedCollection new.
	errors := OrderedCollection new.
	errorCallbacks := OrderedCollection new.
	hasBeenDeployed := false