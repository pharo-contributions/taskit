Extension { #name : #Exception }

{ #category : #'*TaskItForkIt' }
Exception >> isException [
	^ true
]

{ #category : #'*TaskItForkIt' }
Exception >> stonOn: aWriter [
	| csignalContext chandlerContext couterContext |
	csignalContext := signalContext.
	chandlerContext := handlerContext.
	couterContext := outerContext.
	signalContext := nil.
	handlerContext := nil.
	outerContext := nil.
	super stonOn: aWriter.
	signalContext := csignalContext.
	handlerContext := chandlerContext.
	outerContext := couterContext
]
