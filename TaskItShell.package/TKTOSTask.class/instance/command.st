as yet unclassified
command
	| command |
	command := block value: TKTCommandDeclaration new.
	self assert: command isCommandDeclaration.
	^ command