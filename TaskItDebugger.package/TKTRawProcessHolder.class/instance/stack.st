query
stack
	^ contextHolders
		ifEmpty: [ #() ]
		ifNotEmpty: [ self stackStartingAt: contextHolders first ]