Extension { #name : #MessageSend }

{ #category : #'*TaskItForkIt' }
MessageSend >> asArchetypedTaskOn: aTKTArchetype [ 

	^ TKTArchetypedTask new
		valuable: self ;
		archetype: aTKTArchetype;
		yourself 
]
