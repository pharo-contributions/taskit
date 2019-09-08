"
An archetype aware pool is a simple dispatcher of tasks .It spawn a workerpool per archetype. The classical taskit is extended to make it tasks to use TKTArchetype thisImage. 
"
Class {
	#name : #TKTArchetypeAwarePool,
	#superclass : #Object,
	#instVars : [
		'inverseProxy',
		'pool',
		'archetypedControllers',
		'defaultSerializerSelector'
	],
	#category : #'TaskItForkIt-Worker'
}

{ #category : #creating }
TKTArchetypeAwarePool class >> createDefault [
	^ self createDefaultWithPool: TKTCommonQueueWorkerPool createDefault
]

{ #category : #creating }
TKTArchetypeAwarePool class >> createDefaultWithPool: aPool [
	^ self new
		initializeWithPool: aPool;
		defaultSerializerSelector: #xstoned;
		yourself
]

{ #category : #accessing }
TKTArchetypeAwarePool >> amountOfTasksAt: aTKTArchetype [
	^ self inverseProxy amountOfTasksFor: aTKTArchetype
]

{ #category : #initialization }
TKTArchetypeAwarePool >> cleanUpImageToStart [
	TKTConfiguration watchDog stopWatching: self.
	pool
		ifNotNil: [ pool cleanUpImageToStart.
			pool = TKTConfiguration runner
				ifFalse: [ pool stop ] ].
	archetypedControllers
		ifNotNil: [ archetypedControllers do: #cleanUpImageToStart ].
	inverseProxy ifNotNil: [ :r | r cleanUpImageToStart ].
	archetypedControllers removeAll.
	pool := nil
]

{ #category : #accessing }
TKTArchetypeAwarePool >> defaultSerializerSelector [
	^ defaultSerializerSelector
]

{ #category : #accessing }
TKTArchetypeAwarePool >> defaultSerializerSelector: aDefaultSerializerSelector [
	defaultSerializerSelector := aDefaultSerializerSelector
]

{ #category : #service }
TKTArchetypeAwarePool >> ensureIsWorking [
	archetypedControllers
		do: [ :controller | controller ensureIsWorking ]
]

{ #category : #scheduling }
TKTArchetypeAwarePool >> failTaskExecution: aTaskExecution [
	[ self error: aTaskExecution backend errorMessage ]
		on: Error
		do: [ :e | 
			self inverseProxy
				deployFutureResult:
					{aTaskExecution id.
					e} ]
]

{ #category : #scheduling }
TKTArchetypeAwarePool >> future: aTask [
	^ aTask asTask future: self
]

{ #category : #scheduling }
TKTArchetypeAwarePool >> futureArchetypedTask: aTask [
	| execution |
	execution := aTask asTask futureTaskExecutionFor: self.
	(self privateArchetypedControllerFor: aTask archetype)
		scheduleTaskExecution: execution.
	^ execution future
]

{ #category : #testing }
TKTArchetypeAwarePool >> includesArchetype: aTKTArchetype [
	^ archetypedControllers
		includes: [ :controller | controller respondsToArchetype: aTKTArchetype ]
]

{ #category : #initialization }
TKTArchetypeAwarePool >> initializeWithPool: aPool [
	pool := aPool.
	archetypedControllers := Set new.
	TKTConfiguration watchDog watch: self
]

{ #category : #accessing }
TKTArchetypeAwarePool >> inverseProxy [
	^ inverseProxy
		ifNil: [ inverseProxy := TKTOutgoingTasksService new.
			inverseProxy top: self.
			inverseProxy start.
			inverseProxy ]
]

{ #category : #testing }
TKTArchetypeAwarePool >> isDebuggingCompatible [
	^ true
]

{ #category : #testing }
TKTArchetypeAwarePool >> isLocalThreadRunner [
	^ false 
]

{ #category : #testing }
TKTArchetypeAwarePool >> isUIRunner [
	^ false 
]

{ #category : #testing }
TKTArchetypeAwarePool >> kkc [

		
		[ |  result errors  suite |
	errors := OrderedCollection new. 
	result := TestResult new.
	suite := TestSuite new.
	 #(#testPackageOfMethodFromTraits #testPackageOfMethodFromTraitsAfterCreation #testPackageOfMethodFromTraitsAfterCreationOverriden #testPackageOfMethodFromTraitsOverriden #testPackageOfMethodFromTraitsOverridenAndRemoved #testPackageOfMethodFromTraitsOverridenModifiedKeepPackage #testPackageOfMethodFromTraitsRemoved #testPackageOfRemovedTrait #testTraitMethodPackage #testTraitPackage) do: [ : testSelector | suite addTest: (T2TraitWithPackagesTest selector: testSelector) ].
 #(#testGivenAMethodNodeWhenSourceAvailableThenSourceReturnedAsResultOfFormatting #testGivenAMethodNodeWhenSourceNotAvailableThenSelectorWithWarningMessageReturnedAsResultOfFormatting) do: [ : testSelector | suite addTest: (RBNullFormatterTest selector: testSelector) ].
 #(#testRefactoring #testRemoveClassWithBadName #testRemoveClassWithReferences #testRemoveClassWithSubclasses #testTransform) do: [ : testSelector | suite addTest: (RBRemoveClassTransformationTest selector: testSelector) ].
 #(#testIssue7368) do: [ : testSelector | suite addTest: (MCSubDirectoryRepositoryTest selector: testSelector) ].
 #(#testChangingHelpAffectTheWidget #testEnabledAffectWidget #testHidePresenterHidesWidget #testRightClickShowsMenu #testSelectManyIndexesKeepsAllSelected #testSelectPresenterIndexOutsideRangeUnsetsSelectedIndexInWidget #testSelectPresenterIndexSetsSelectedIndexInWidget #testSelectPresenterItemSetsSelectedIndexInWidget #testSelectWidgetIndexRaisesSelectionIndexChangeEventOnce #testSelectWidgetIndexRaisesSelectionIndexChangeEventWithSelectedIndex #testShowPresenterShowsWidget #testSubscribeToEventDoesNotRaiseEvent #testUnselectAllInWidgetRaisesEmptySelectionChangeEvent #testUnselectAllInWidgetRaisesSelectionIndexChangeEventOnce #testVisibilityWithBlock #testVisibilityWithBlock2) do: [ : testSelector | suite addTest: (SpListAdapterMultipleSelectionTest selector: testSelector) ].
 #(#testShouldGetDirectDependencies #testShouldGetUnresolvedDependencies) do: [ : testSelector | suite addTest: (DADependencyCheckerTest selector: testSelector) ].
 #(#testAbstractInstanceVariable #testAbstractWithAssignmentUsed #testAbstractWithDefaultNamesUsed #testInheritedName #testMetaclassInstanceVariables #testNonExistantName) do: [ : testSelector | suite addTest: (RBAbstractInstanceVariableTest selector: testSelector) ].
 #(#testAssertionEqualsDetected #testSuccessfullTestWithHalt) do: [ : testSelector | suite addTest: (GTSUnitDebuggerSmokeTest selector: testSelector) ].
 #(#testExample #testOpenWithSpec) do: [ : testSelector | suite addTest: (SearchableTreeTest selector: testSelector) ].
 #(#test0CopyTest #test0FixtureAsStringCommaAndDelimiterTest #test0FixtureCloneTest #test0FixtureConverAsSortedTest #test0FixtureDictionaryAddingTest #test0FixtureDictionaryAssocitionAccess #test0FixtureDictionaryCopyingTest #test0FixtureDictionaryElementAccess #test0FixtureDictionaryEnumeratingTest #test0FixtureDictionaryIncludes #test0FixtureDictionaryIncludesIdentity #test0FixtureDictionaryKeyAccess #test0FixtureDictionaryKeysValuesAssociationsAccess #test0FixtureDictionaryRemovingTest #test0FixtureEmptyTest #test0FixtureIncludeTest #test0FixtureIterateTest #test0FixtureOccurrencesForMultiplinessTest #test0FixtureOccurrencesTest #test0FixturePrintTest #test0FixturePutTest #test0FixtureSetAritmeticTest #test0FixtureTConvertTest #test0TSizeTest #test0TStructuralEqualityTest #testAdd #testAddAll #testAddWithKeyAlreadyIn #testAddWithKeyNotIn #testAllSatisfy #testAllSatisfyEmpty #testAnySastify #testAsArray #testAsBag #testAsByteArray #testAsCommaStringEmpty #testAsCommaStringMore #testAsCommaStringOne #testAsIdentitySet #testAsOrderedCollection #testAsSet #testAsSortedArray #testAsSortedCollection #testAsSortedCollectionWithSortBlock #testAsStringOnDelimiterEmpty #testAsStringOnDelimiterLastEmpty #testAsStringOnDelimiterLastMore #testAsStringOnDelimiterLastOne #testAsStringOnDelimiterMore #testAsStringOnDelimiterOne #testAssociationAt #testAssociationAtError #testAssociationAtIfAbsent #testAssociationAtIfPresent #testAssociationAtIfPresentifAbsent #testAssociations #testAssociationsDo #testAssociationsSelect #testAt #testAtIfAbsent #testAtIfAbsentPut #testAtIfPresent #testAtIfPresentIfAbsent #testAtIfPresentIfAbsentPut #testAtPut #testAtPutDict #testAtPutNil #testAtPutTwoValues #testBasicCollect #testBasicCollectEmpty #testBasicCollectThenDo #testCollect #testCollectOnEmpty #testCollectThenDoOnEmpty #testCollectThenSelectOnEmpty #testCopyCreatesNewObject #testCopyEmpty #testCopyEmptyWith #testCopyEmptyWithoutAll #testCopyEquals #testCopyNonEmpty #testCopyNonEmptyWith #testCopyNonEmptyWithoutAll #testCopyNonEmptyWithoutAllNotIncluded #testCopyNotSame #testCopySameClass #testCoverage #testDeclareFrom #testDetect #testDetectIfFoundIfNoneWhenNobodyIsFound #testDetectIfFoundIfNoneWhenSomethingIsFound #testDetectIfFoundIfNoneWhenSomethingIsFoundIgnoringTheFoundObject #testDetectIfFoundWhenNobodyIsFound #testDetectIfFoundWhenSomethingIsFound #testDetectIfFoundWhenSomethingIsFoundIgnoringTheFoundObject #testDetectIfNone #testDictionaryConcatenationWithCommonKeys #testDictionaryConcatenationWithCommonKeysDifferentValues #testDictionaryConcatenationWithoutCommonKeys #testDictionaryPublicProtocolCompatibility #testDifference #testDifferenceWithNonNullIntersection #testDifferenceWithSeparateCollection #testDo #testDo2 #testDoSeparatedBy #testDoWithout #testEqualSign #testEqualSignIsTrueForNonIdenticalButEqualCollections #testEqualSignOfIdenticalCollectionObjects #testEquality #testFlatCollect #testFlatCollect2 #testFlatCollect3 #testHasBindingThatBeginsWith #testIdentityIncludesNonSpecificComportement #testIfEmpty #testIfEmptyifNotEmpty #testIfNotEmpty #testIfNotEmptyifEmpty #testIncludeAssociation #testIncludes #testIncludesAllNoneThere #testIncludesAnyAllThere #testIncludesAnyNoneThere #testIncludesAssociation #testIncludesAssociationNoValue #testIncludesAssociationWithValue #testIncludesComportementForDictionnary #testIncludesElementIsNotThere #testIncludesElementIsThere #testIncludesIdentityBasicComportement #testIncludesIdentitySpecificComportement #testIncludesKey #testInjectInto #testIntersectionBasic #testIntersectionEmpty #testIntersectionItself #testIntersectionTwoSimilarElementsInIntersection #testIsDictionary #testIsEmpty #testIsEmptyOrNil #testIsHealthy #testKeyAtIdentityValue #testKeyAtIdentityValueIfAbsent #testKeyAtValue #testKeyAtValueIfAbsent #testKeyForIdentity #testKeys #testKeysAndValuesDo #testKeysAndValuesRemove #testKeysDo #testKeysSortedSafely #testMethodsOfTheClassShouldNotBeRepeatedInItsSuperclasses #testNew #testNewFrom #testNewFromKeysAndValues #testNewFromKeysAndValues2 #testNewFromPairs #testNilHashCollision #testNoneSatisfy #testNoneSatisfyEmpty #testNotEmpty #testOccurrencesOf #testOccurrencesOfEmpty #testOccurrencesOfForMultipliness #testOccurrencesOfNotIn #testOtherDictionaryEquality #testPrintElementsOn #testPrintNameOn #testPrintOn #testPrintOnDelimiter #testPrintOnDelimiterLast #testReject #testRejectAllThenCollect #testRejectAllThenDo #testRejectEmpty #testRejectNoReject #testRejectThenCollect #testRejectThenCollectEmpty #testRejectThenDo #testRejectThenDoOnEmpty #testRemove #testRemoveAll #testRemoveKey #testRemoveKeyIfAbsent #testSelect #testSelectIsNotShallowCopy #testSelectNoneThenCollect #testSelectNoneThenDo #testSelectOnEmpty #testSelectThenCollect #testSelectThenCollectOnEmpty #testSelectThenDo #testSelectThenDoOnEmpty #testSize #testStoreOn #testStoreOnRoundTrip #testStoreOnWithNegativeInteger #testSumNumbers #testTraitExplicitRequirementMethodsMustBeImplementedInTheClassOrInASuperclass #testUnCategorizedMethods #testUnion #testUnionOfEmpties #testValues #testValuesDo) do: [ : testSelector | suite addTest: (SmallDictionaryTest selector: testSelector) ].
 #(#testApplicationUrlEncodingAddAll #testMultiPartFormDataWriteRead #testMultiPartFormDataWriteReadBinary #testReading #testReadingApplicationFormUrlEncoding #testReadingApplicationFormUrlEncodingNoLength #testReadingBinary #testReadingLimited #testStringEntityEncoderInitialization #testUTF8ReadingDetermined #testUTF8ReadingUndetermined #testUTF8Writing #testUnspecifiedEncoding #testWritingApplicationUrlEncoding #testWritingApplicationUrlEncodingWithTextEncodingLatin1 #testWritingApplicationUrlEncodingWithTextEncodingUtf8) do: [ : testSelector | suite addTest: (ZnEntityTest selector: testSelector) ].
 #(#testLocation #testProjectTagsUrlFor #testSelfHostedLocation #testSelfHostedLocationWithNonDefaultSSHPort) do: [ : testSelector | suite addTest: (MCGitlabRepositoryTest selector: testSelector) ].
 #(#testStartForReplacement #testStartForReplacement02) do: [ : testSelector | suite addTest: (RBVariableNodeTest selector: testSelector) ].
 #(#testClassVariable #testMetaclassFailure #testRefactoring #testTransform #testVariableAlreadyExists #testVariableDoesNotExist) do: [ : testSelector | suite addTest: (RBRenameVariableTransformationTest selector: testSelector) ].
 #(#testDynamicVariable #testDynamicVariableAccessFromDifferentProcess #testDynamicVariableBlockReturnValue #testDynamicVariableRemovedAfterUse #testExecutionEnvironment #testInheritableVariable #testInheritingExecutionEnvironment #testLocalVariable) do: [ : testSelector | suite addTest: (ProcessSpecificTest selector: testSelector) ].
 #(#testRenamePackage #testRenamePackageToOwnTagName #testRenamePackageToOwnTagNameWithClassesInRoot #testRenamePackageUppercase #testUnregisterPackage) do: [ : testSelector | suite addTest: (RPackageRenameTest selector: testSelector) ].
 #(#testChangingHelpAffectTheWidget #testEnabledAffectWidget #testHidePresenterHidesWidget) do: [ : testSelector | suite addTest: (SpAthensStaticPresenterTest selector: testSelector) ]..
	[ result registerPartialResult: suite run ] on: Error do: [ : e | errors add:{  e messageText } .e resume ]]
]

{ #category : #scheduling }
TKTArchetypeAwarePool >> maxBackends [
	^ 2
]

{ #category : #notifications }
TKTArchetypeAwarePool >> noteRemoteWorkerAt: anUrl forBackendHashed: aHash [
	archetypedControllers
		do:
			[ :controller | controller noteRemoteWorkerAt: anUrl forBackendHashed: aHash ]
]

{ #category : #notifications }
TKTArchetypeAwarePool >> noteTaskHasFinished: futureExecution [
	archetypedControllers
		do: [ :a | a noteTaskHasFinished: futureExecution ]
]

{ #category : #accessing }
TKTArchetypeAwarePool >> pool: aTKTCommonQueueWorkerPool [ 
	pool := aTKTCommonQueueWorkerPool
]

{ #category : #accessing }
TKTArchetypeAwarePool >> privateArchetypedControllerFor: anArchetype [
	| archetypeWithForkit |
	anArchetype = TKTArchetype pharoCurrent
		ifFalse: [ archetypeWithForkit := anArchetype + TKTProject forkit ]
		ifTrue: [ archetypeWithForkit := anArchetype ].
	^ archetypedControllers
		detect: [ :a | a archetype = archetypeWithForkit ]
		ifNone: [ | new |
			new := TKTArchetypedQueueController new.
			archetypedControllers add: new.
			new
				archetype: archetypeWithForkit
					pool: self
					backends: self maxBackends;
				yourself ]
]

{ #category : #scheduling }
TKTArchetypeAwarePool >> privateFuture: aTask [
	^ pool privateFuture: aTask
]

{ #category : #scheduling }
TKTArchetypeAwarePool >> privateSchedule: aTKTGenericTask [
	pool privateSchedule: aTKTGenericTask
]

{ #category : #scheduling }
TKTArchetypeAwarePool >> recoverOngoingTasks: aCollectionOfTaskExecutions [
	self logCr: 'Recovering tasks: ', aCollectionOfTaskExecutions size asString.  
	aCollectionOfTaskExecutions ifEmpty: [ ^ self ].
	aCollectionOfTaskExecutions
		reject: [ :t | t shouldRetry ]
		thenDo: [ :t | self failTaskExecution: t ].
		
	aCollectionOfTaskExecutions 
		select: [ :t | t shouldRetry ]
		thenDo: [ :aTaskExecution | 
			
			(self privateArchetypedControllerFor: aTaskExecution archetype)
				scheduleTaskExecution: aTaskExecution.
			aTaskExecution markAsRecovered.	
			 ].
	
]

{ #category : #scheduling }
TKTArchetypeAwarePool >> registerNotDeployableTaskExecution: aTaskExecution [
	self inverseProxy registerNotDeployable: aTaskExecution
]

{ #category : #scheduling }
TKTArchetypeAwarePool >> registerTaskExecution: aTaskExecution [
	self inverseProxy register: aTaskExecution
]

{ #category : #service }
TKTArchetypeAwarePool >> requestTaskForBackend: aHash [
	self logCr: aHash asString , ' requested a task'.
	^ (archetypedControllers
		detect: [ :controller | controller managesBackendId: aHash ])
		requestTaskOrNilForBackend: aHash
]

{ #category : #scheduling }
TKTArchetypeAwarePool >> schedule: aTask [
	aTask asTask schedule: self
]

{ #category : #scheduling }
TKTArchetypeAwarePool >> schedule: aTask timeout: aTimeout [
	^ pool schedule: aTask timeout: aTimeout
]

{ #category : #scheduling }
TKTArchetypeAwarePool >> scheduleArchetypedTask: aTask [
	| execution |
	execution := aTask asTask futureTaskExecutionFor: self.
	(self privateArchetypedControllerFor: aTask archetype)
		scheduleTaskExecutionNotDeployable: execution
]

{ #category : #scheduling }
TKTArchetypeAwarePool >> scheduleTaskExecution: aTaskExecution [
	^ pool scheduleTaskExecution: aTaskExecution
]

{ #category : #scheduling }
TKTArchetypeAwarePool >> scheduleTimeout: timeout on: aTaskExecution [
	^ pool scheduleTimeout: timeout on: aTaskExecution
]

{ #category : #stop }
TKTArchetypeAwarePool >> stop [
	TKTConfiguration watchDog stopWatching: self.
	archetypedControllers do: #stop.
	inverseProxy ifNotNil: [ :r | r stop ].
	inverseProxy := nil.
	pool
		ifNotNil: [ pool = TKTConfiguration runner
				ifFalse: [ pool stop ] ].
	archetypedControllers removeAll.
	pool := nil
]

{ #category : #stop }
TKTArchetypeAwarePool >> stopAndDelete [
	TKTConfiguration watchDog stopWatching: self.
	archetypedControllers do: #stopAndDelete.
	inverseProxy ifNotNil: [ :r | r stop ].
	inverseProxy := nil.
	pool
		ifNotNil: [ pool = TKTConfiguration runner
				ifFalse: [ pool stop ] ].
	archetypedControllers removeAll.
	pool := nil
]

{ #category : #accessing }
TKTArchetypeAwarePool >> taskQueueSize: aTKTArchetype [
	^ pool taskQueueSize
]

{ #category : #scheduling }
TKTArchetypeAwarePool >> url [
	^ inverseProxy url
]
