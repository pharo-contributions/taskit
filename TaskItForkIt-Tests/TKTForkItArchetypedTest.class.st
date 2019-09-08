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
		forSelector: #archetype addOptions: {TKTArchetype pharoCurrent};
		yourself
]

{ #category : #running }
TKTForkItArchetypedTest >> archetype: anArchetype [
	archetype := anArchetype
]

{ #category : #running }
TKTForkItArchetypedTest >> tearDown [
]
