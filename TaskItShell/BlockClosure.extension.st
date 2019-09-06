Extension { #name : #BlockClosure }

{ #category : #'*TaskItShell' }
BlockClosure >> asOSTask [
	| declaration |
	self deprecated: 'Use FileReference>>command instead. '.
	declaration := self value: TKTShellCommandDeclaration new.
	self assert: declaration isCommandDeclaration.
	^ declaration
]
