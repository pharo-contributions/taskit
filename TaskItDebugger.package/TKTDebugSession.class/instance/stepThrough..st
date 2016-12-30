debugging actions
stepThrough: aContext
	"Send messages until you return to selectedContext.
	 Used to step into a block in the method."
	| holder |
	(self canStepFrom: aContext) ifFalse: [ ^ self ].

	aContext willSend ifFalse: [ ^ self stepOver: aContext ].

	holder := exceptionProcessHolder holderForContext: aContext.
	holder ifNil: [ ^ super stepThrough: aContext ].
	
	holder stepToHome.
	self updateContextTo: (self stepToFirstInterestingBytecodeIn: holder process).
			
	self triggerEvent: #stepThrough 