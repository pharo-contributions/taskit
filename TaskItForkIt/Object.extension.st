Extension { #name : #Object }

{ #category : #'*TaskItForkIt' }
Object >> isException [ 
	^ false
]

{ #category : #'*TaskItForkIt' }
Object >> stonOn: stonWriter [
	"Encode non-variable classes with a map of their instance variable and values.
	Override to customize and add a matching #fromSton: (see implementors)."

	self class isVariable
		ifTrue: [ stonWriter writeNull ]
		ifFalse: [ stonWriter writeObject: self ]
]
