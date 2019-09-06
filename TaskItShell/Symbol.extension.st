Extension { #name : #Symbol }

{ #category : #'*TaskItShell' }
Symbol >> command [
	^ TKTShellCommandDeclaration new
		command: self asString;
		yourself
]
