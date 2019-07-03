Extension { #name : #BlockClosure }

{ #category : #'*TaskItForkIt' }
BlockClosure >> asArchetypedTaskOn: aTKTArchetype [
	^ self isClean
		ifTrue: [ TKTArchetypedTask new
				valuable: self;
				archetype: aTKTArchetype;
				yourself ]
		ifFalse: [ self error: 'Block must be clean' ]
]

{ #category : #'*TaskItForkIt' }
BlockClosure >> stonOn: stonWriter [
	(TKTBlockClosureWriter on: self) stonOn: stonWriter
]
