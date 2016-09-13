as yet unclassified
testTaskBlockShouldReturnACommandDeclarationOrFail
	" command: aSymbol options: anArrayOfOptions arguments: anArrayArguments"

	|  future |
	future := [ :spec | self ] asOSTask future.
	self should: [ future synchronizeTimeout: 1 second ] raise: Error