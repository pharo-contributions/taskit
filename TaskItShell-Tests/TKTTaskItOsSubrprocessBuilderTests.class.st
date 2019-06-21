Class {
	#name : #TKTTaskItOsSubrprocessBuilderTests,
	#superclass : #TKTTestCase,
	#category : 'TaskItShell-Tests'
}

{ #category : #'as yet unclassified' }
TKTTaskItOsSubrprocessBuilderTests >> testTaskBlockReceivesACommandDeclaration [
	" command: aSymbol options: anArrayOfOptions arguments: anArrayArguments"

	| assertion future |
	future := [ :spec | 
	assertion := spec isKindOf: TKTShellCommandDeclaration.
	spec ls ] asOSTask future.
	future waitForCompletion: 1 second.
	self assert: assertion description: 'Spec is not a command declaration'
]

{ #category : #'as yet unclassified' }
TKTTaskItOsSubrprocessBuilderTests >> testTaskBlockShouldReturnACommandDeclarationOrFail [
	" command: aSymbol options: anArrayOfOptions arguments: anArrayArguments"

	| future worker |
	worker := TKTWorker new.
	worker exceptionHandler: TKTTestExceptionHandler new.
	worker start.
	future := [ :spec | self ] asOSTask future: worker.
	future waitForCompletion: 1 second.
	self assert: future isFailure description: ' Future should fail! '
]

{ #category : #'as yet unclassified' }
TKTTaskItOsSubrprocessBuilderTests >> testTaskExecutionReturnsStdOutputAsResult [
	" command: aSymbol options: anArrayOfOptions arguments: anArrayArguments"

	|  future  value |
	future := [ :spec | spec ls argument: '/'  ] asOSTask future.
	value := (future synchronizeTimeout: 1 second) lines.
	self assert: value  size > 1 description: ' expected at least one line as result of LS '. 
	self assert: (value includes: 'home') description: ' ls in / in unix based system should include home '.
]
