Extension { #name : #FileReference }

{ #category : #'*TaskItShell' }
FileReference >> command [
	^ TKTCommandDeclaration new
		command: self fullName;
		yourself
]
