Class {
	#name : #TKTArchetypeBuildAndDeployTestCase,
	#superclass : #ParametrizedTestCase,
	#instVars : [
		'archetype',
		'deployer',
		'session'
	],
	#category : #'TaskItForkIt-Tests'
}

{ #category : #tests }
TKTArchetypeBuildAndDeployTestCase class >> testParameters [
	^ ParametrizedTestMatrix new
		forSelector: #archetype
			addOptions:
			{TKTArchetype pharoCurrent.
			TKTArchetype pharo70.
			TKTArchetype pharo80};
		yourself
]

{ #category : #tests }
TKTArchetypeBuildAndDeployTestCase >> archetype: anArchetype [
	archetype := anArchetype 
]

{ #category : #tests }
TKTArchetypeBuildAndDeployTestCase >> setUp [
	super setUp.
	session := Smalltalk session.
	deployer := TKTFileOrientedDeployer default.
]

{ #category : #tests }
TKTArchetypeBuildAndDeployTestCase >> tearDown [
	session = Smalltalk session
		ifTrue: [ TKTSystem rm
				option: '-rf';
				argument: (#/ asFileReference / #tmp / archetype name) fullName;
				future.
			TKTSystem rm
				option: '-rf';
				argument: ('pharo-local' asFileReference / #forking) fullName;
				future ]
]

{ #category : #tests }
TKTArchetypeBuildAndDeployTestCase >> testCommunicationStonHasNoDependancies [
	self assert: archetype dependancies size equals: 0
]

{ #category : #tests }
TKTArchetypeBuildAndDeployTestCase >> testDeployDeploysAFunctionalEnvironment [
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
