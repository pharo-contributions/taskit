testing
canStepFrom: aContext
	| holder |
	holder := exceptionProcessHolder holderForContext: aContext.
	^ holder
		ifNotNil: [ holder canStep ]
		ifNil: [ (self isContextPostMortem: aContext) not ]