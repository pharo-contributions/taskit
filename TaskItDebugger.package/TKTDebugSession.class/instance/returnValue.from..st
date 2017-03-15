debugging actions
returnValue: anObject from: aContext
	"Force a return of a given value to the previous context!"
	(self canStepFrom: aContext) ifFalse: [^ self].

	super
		returnValue: anObject
		from: aContext