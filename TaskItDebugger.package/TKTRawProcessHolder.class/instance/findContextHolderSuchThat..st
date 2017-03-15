query
findContextHolderSuchThat: aBlock
	^ contextHolders
		detect: aBlock
		ifNone: [
			self process isTaskItRawProcess
				ifTrue: [ self process masterProcessHolder findContextHolderSuchThat: aBlock ]
				ifFalse: [ nil ] ]