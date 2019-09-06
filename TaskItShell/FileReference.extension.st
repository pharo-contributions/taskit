Extension { #name : #FileReference }

{ #category : #'*TaskItShell' }
FileReference >> command [
	^ TKTShellCommandDeclaration new
		command: self fullName;
		yourself
]
