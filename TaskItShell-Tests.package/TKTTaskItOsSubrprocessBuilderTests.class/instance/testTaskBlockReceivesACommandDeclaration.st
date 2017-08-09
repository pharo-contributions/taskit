as yet unclassified
testTaskBlockReceivesACommandDeclaration
	" command: aSymbol options: anArrayOfOptions arguments: anArrayArguments"

	| assertion future |
	future := [ :spec | 
	assertion := spec isKindOf: TKTCommandDeclaration.
	spec ls ] asOSTask future.
	future waitForCompletion: 1 second.
	self assert: assertion description: 'Spec is not a command declaration'