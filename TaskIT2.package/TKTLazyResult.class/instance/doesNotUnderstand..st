message handling
doesNotUnderstand: aMessage
	
	cancelled ifTrue: [
		Error signal: 'The process was cancelled'.
	].

	^ self perform: aMessage selector withArguments: aMessage arguments.
	