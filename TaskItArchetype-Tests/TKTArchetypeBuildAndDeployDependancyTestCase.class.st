Class {
	#name : #TKTArchetypeBuildAndDeployDependancyTestCase,
	#superclass : #ParametrizedTestCase,
	#instVars : [
		'archetype',
		'deployer',
		'session',
		'project'
	],
	#category : #'TaskItArchetype-Tests'
}

{ #category : #'building suites' }
TKTArchetypeBuildAndDeployDependancyTestCase class >> testParameters [
	^ ParametrizedTestMatrix new
		forSelector: #archetype
			addOptions:
			{TKTArchetype pharo70.
			TKTArchetype pharo80};
		forSelector: #project
			addOptions:
			{TKTProject taskit.
			TKTProject baselineTests};
		yourself
]

{ #category : #tests }
TKTArchetypeBuildAndDeployDependancyTestCase >> archetype: anArchetype [
	archetype := anArchetype 
]

{ #category : #tests }
TKTArchetypeBuildAndDeployDependancyTestCase >> project: aProject [
	project := aProject
]

{ #category : #tests }
TKTArchetypeBuildAndDeployDependancyTestCase >> runCaseManaged [
	^ self runCase
]

{ #category : #tests }
TKTArchetypeBuildAndDeployDependancyTestCase >> setUp [
	super setUp.
	session := Smalltalk session.
	deployer := TKTFileOrientedDeployer default.
]

{ #category : #tests }
TKTArchetypeBuildAndDeployDependancyTestCase >> tearDown [
	session = Smalltalk session
		ifTrue: [ (TKTSystem rm
				option: '-rf';
				argument: (#/ asFileReference / #tmp / archetype name) fullName;
				future) synchronizeTimeout: 1 minute.
			(TKTSystem rm
				option: '-rf';
				argument: ('pharo-local' asFileReference / #forking) fullName;
				future) synchronizeTimeout: 1 minute ]
]

{ #category : #tests }
TKTArchetypeBuildAndDeployDependancyTestCase >> testDeployDeploysAFunctionalEnvironment [
	| deployed |
	deployed := deployer deployAtDefaultLocation: archetype + project.
	self assert: deployed vmFolder exists.
	self assert: deployed imageFile exists.
	self assert: deployed changesFile exists.
	self assert: deployed sourcesFile exists
]
