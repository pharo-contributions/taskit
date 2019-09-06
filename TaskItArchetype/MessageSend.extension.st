Extension { #name : #MessageSend }

{ #category : #'*TaskItArchetype' }
MessageSend >> asArchetypedTaskOn: aTKTArchetype [ 

	^ TKTArchetypedTask new
		valuable: self ;
		archetype: aTKTArchetype;
		yourself 
]
