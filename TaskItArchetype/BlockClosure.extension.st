Extension { #name : #BlockClosure }

{ #category : #'*TaskItArchetype' }
BlockClosure >> asArchetypedTaskOn: aTKTArchetype [
	^ self isClean
		ifTrue: [ TKTArchetypedTask new
				valuable: self;
				archetype: aTKTArchetype;
				yourself ]
		ifFalse: [ self error: 'Block must be clean' ]
]
