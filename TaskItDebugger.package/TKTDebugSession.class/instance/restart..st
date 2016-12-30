debugging actions
restart: aContext
	"Proceed from the initial state of selectedContext." 
	"Closing now depends on a setting (RestartAlsoProceeds class variable) --> not supported in this version"

	(self canStepFrom: aContext) ifFalse: [^ self].
	
	super restart: aContext
	