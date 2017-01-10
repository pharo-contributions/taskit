debugging actions
stepOver: aContext
	"Send the selected message in selectedContext, and regain control 
	after the invoked method returns."
	
	| newContext holder |
	(self canStepFrom: aContext) ifFalse: [ ^ self ].

	holder := exceptionProcessHolder holderForContext: aContext.
	holder ifNil: [ ^ super stepOver: aContext ].
	
	newContext := holder completeStep.

	self updateContextTo:  
		(newContext == aContext
			ifTrue: [ self stepToFirstInterestingBytecodeIn: holder process ]
			ifFalse: [ newContext ]).

	self triggerEvent: #stepOver