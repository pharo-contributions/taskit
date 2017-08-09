debugging actions
stepInto: aContext
	"Send the selected message in selectedContext, and take control in 
	the method invoked to allow further step or send."

	| holder |
	(self canStepFrom: aContext) ifFalse: [ ^ self ].
	
	aContext willSend ifFalse: [ ^ self stepOver: aContext ].
	
	holder := exceptionProcessHolder holderForContext: aContext.
	holder ifNil: [ ^ super stepInto: aContext ].
	
	holder step.
	
	self updateContextTo: (self stepToFirstInterestingBytecodeIn: holder process).
	
	self triggerEvent: #stepInto