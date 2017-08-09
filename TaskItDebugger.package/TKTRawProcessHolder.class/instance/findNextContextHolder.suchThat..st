query
findNextContextHolder: aContextHolder suchThat: aBlock
	aContextHolder index >= contextHolders size ifTrue: [ ^ nil ].
	
	contextHolders
		from: aContextHolder index + 1
		to: contextHolders size
		do: [ :contextHolder |
			(aBlock value: contextHolder) ifTrue: [ ^ contextHolder ] ].
		
	^ nil