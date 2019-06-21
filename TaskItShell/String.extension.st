Extension { #name : #String }

{ #category : #'*TaskItShell' }
String >> command [
	^ TKTShellCommandDeclaration new
		command: self;
		yourself
]
