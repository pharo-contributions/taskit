accessing
command
	| command |
	command := block value: TKTCommandDeclaration new.
	command isCommandDeclaration
		ifFalse: [ Error
				signal: 'The result of the OSTask block must be a command declaration' ].
	^ command