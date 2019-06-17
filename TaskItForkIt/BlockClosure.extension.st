Extension { #name : #BlockClosure }

{ #category : #'*TaskItForkIt' }
BlockClosure >> asArchetypedTaskOn: aTKTArchetype [ 
	 
	
	^ TKTArchetypedTask new
		valuable: self;
		archetype: aTKTArchetype;
		yourself 
]
