Class {
	#name : #TKTSameImageArchetypeTestBuilding,
	#superclass : #ParametrizedTestCase,
	#instVars : [
		'archetype',
		'deployer',
		'session'
	],
	#category : #'TaskItForkIt-Tests'
}

{ #category : #tests }
TKTSameImageArchetypeTestBuilding class >> testParameters [
	^ ParametrizedTestMatrix new
		forSelector: #archetype
			addOptions:
			{TKTArchetype pharoCurrent.
			TKTArchetype pharo70.
			TKTArchetype pharo80};
		yourself
]

{ #category : #tests }
TKTSameImageArchetypeTestBuilding >> archetype: anArchetype [
	archetype := anArchetype 
]

{ #category : #tests }
TKTSameImageArchetypeTestBuilding >> setUp [
	super setUp.
	session := Smalltalk session.
	deployer := TKTFileOrientedDeployer default.
]

{ #category : #tests }
TKTSameImageArchetypeTestBuilding >> tearDown [
	session = Smalltalk session
		ifTrue: [ (TKTSystem rm
				option: '-rf';
				argument: (#/ asFileReference / #tmp / archetype name) fullName;
				future) synchronizeTimeout: 5 seconds.
			(TKTSystem rm
				option: '-rf';
				argument: ('pharo-local' asFileReference / #forking) fullName;
				future) synchronizeTimeout: 5 seconds ]
]

{ #category : #tests }
TKTSameImageArchetypeTestBuilding >> testCommunicationStonHasNoDependancies [
	self assert: archetype dependancies size equals: 0
]

{ #category : #tests }
TKTSameImageArchetypeTestBuilding >> testDeployDeploysAFunctionalEnvironment [
	| destination deployed |
	destination := (#/ asFileReference / #tmp / archetype name
		/ UUID new asString)
		ensureCreateDirectory;
		yourself.
	deployed := deployer deploy: archetype at: destination.
	self assert: deployed vmFolder exists.
	self assert: deployed imageFile exists.
	self assert: deployed changesFile exists.
	self assert: deployed sourcesFile exists.

	

]
