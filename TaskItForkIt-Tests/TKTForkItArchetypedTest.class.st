Class {
	#name : #TKTForkItArchetypedTest,
	#superclass : #TKTTestCase,
	#instVars : [
		'archetype'
	],
	#category : #'TaskItForkIt-Tests'
}

{ #category : #tests }
TKTForkItArchetypedTest class >> testParameters [
	^ ParametrizedTestMatrix new
		forSelector: #archetype
			addOptions:
			{TKTArchetype pharo80.
			TKTArchetype pharo70.
			TKTArchetype thisImage.
			TKTArchetype pharoCurrent};
		yourself
]

{ #category : #running }
TKTForkItArchetypedTest >> archetype: anArchetype [
	archetype := anArchetype
]
