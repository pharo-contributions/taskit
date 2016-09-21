as yet unclassified
testTaskBlockShouldReturnACommandDeclarationOrFail
	" command: aSymbol options: anArrayOfOptions arguments: anArrayArguments"

	| future worker |
	worker := TKTWorker new.
	worker exceptionHandler: TKTTestExceptionHandler new.
	worker start.
	future := [ :spec | self ] asOSTask future: worker.
	future waitForCompletion: 1 second.
	self assert: future isFailure description: ' Future should fail! '