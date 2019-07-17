Class {
	#name : #TKTArchetypeCreationTestCase,
	#superclass : #TestCase,
	#category : #'TaskItArchetype-Tests'
}

{ #category : #'test defaults' }
TKTArchetypeCreationTestCase >> testArchetypePharo6132PointsTo6132Requirements [
	| currentArchetype |
	currentArchetype := TKTArchetype pharo6132Bits.
	self assert: currentArchetype parent isNil.
	self assert: currentArchetype imageSelector equals: '61'.
	self assert: currentArchetype vmSelector equals: #stable.
	self assert: currentArchetype architectureSelector equals: 32.
	self assert: currentArchetype dependancies isEmpty
]

{ #category : #'test defaults' }
TKTArchetypeCreationTestCase >> testArchetypePharo61PointsTo61Requirements [
	| currentArchetype |
	currentArchetype := TKTArchetype pharo61.
	self assert: currentArchetype parent isNil.
	self assert: currentArchetype imageSelector equals: '61'.
	self assert: currentArchetype vmSelector equals: #stable.
	self assert: currentArchetype architectureSelector equals: 64.
	self assert: currentArchetype dependancies isEmpty
]

{ #category : #'test defaults' }
TKTArchetypeCreationTestCase >> testArchetypePharo7032PointsTo7032Requirements [
	| currentArchetype |
	currentArchetype := TKTArchetype pharo7032Bits.
	self assert: currentArchetype parent isNil.
	self assert: currentArchetype imageSelector equals: '70'.
	self assert: currentArchetype vmSelector equals: #stable.
	self assert: currentArchetype architectureSelector equals: 32.
	self assert: currentArchetype dependancies isEmpty
]

{ #category : #'test defaults' }
TKTArchetypeCreationTestCase >> testArchetypePharo70PointsTo70Requirements [
	| currentArchetype |
	currentArchetype := TKTArchetype pharo70.
	self assert: currentArchetype parent isNil.
	self assert: currentArchetype imageSelector equals: '70'.
	self assert: currentArchetype vmSelector equals: #stable.
	self assert: currentArchetype architectureSelector equals: 64.
	self assert: currentArchetype dependancies isEmpty
]

{ #category : #'test defaults' }
TKTArchetypeCreationTestCase >> testArchetypePharo8032PointsTo8032Requirements [
	| currentArchetype |
	currentArchetype := TKTArchetype pharo8032Bits.
	self assert: currentArchetype parent isNil.
	self assert: currentArchetype imageSelector equals: '80'.
	self assert: currentArchetype vmSelector equals: #stable.
	self assert: currentArchetype architectureSelector equals: 32.
	self assert: currentArchetype dependancies isEmpty
]

{ #category : #'test defaults' }
TKTArchetypeCreationTestCase >> testArchetypePharo80PointsTo80Requirements [
	| currentArchetype |
	currentArchetype := TKTArchetype pharo80.
	self assert: currentArchetype parent isNil.
	self assert: currentArchetype imageSelector equals: '80'.
	self assert: currentArchetype vmSelector equals: #stable.
	self assert: currentArchetype architectureSelector equals: 64.
	self assert: currentArchetype dependancies isEmpty
]

{ #category : #'test defaults' }
TKTArchetypeCreationTestCase >> testArchetypePharoCurrentGetsCurrentEverywhere [
	| currentArchetype |
	currentArchetype := TKTArchetype pharoCurrent.
	self assert: currentArchetype parent isNil.
	self assert: currentArchetype imageSelector equals: #current.
	self assert: currentArchetype vmSelector equals: #current.
	self
		assert: currentArchetype architectureSelector
		equals:
			((Smalltalk image sourceFileVersionString
				indexOfSubCollection: '32bit') > 0
				ifTrue: [ 32 ]
				ifFalse: [ 64 ]).
	self assert: currentArchetype dependancies isEmpty
]

{ #category : #'tests compositions' }
TKTArchetypeCreationTestCase >> testArchetypePlusProjectGivesNewArchetype [
	| archetype subarchetype| 
	archetype := TKTArchetype new.
	subarchetype  := archetype + TKTProject new.
	self assert: archetype parent isNil.
	self assert: subarchetype parent equals: archetype.
]

{ #category : #'tests compositions' }
TKTArchetypeCreationTestCase >> testArchetypePlusProjectGivesNewArchetypeDependenciesAreEmptyInOneNotInOTher [
	| archetype subarchetype |
	archetype := TKTArchetype new.
	subarchetype := archetype + TKTProject new.
	self assert: archetype dependancies isEmpty.
	self assert: subarchetype dependancies size equals: 1
]

{ #category : #'tests compositions' }
TKTArchetypeCreationTestCase >> testArchetypePlusProjectPlusProjectGivesNewArchetype [
	| archetype subarchetype subsubarchetype | 
	archetype := TKTArchetype new.
	subarchetype  := archetype + TKTProject new.
	subsubarchetype := subarchetype + TKTProject new.
	
	self assert: archetype parent isNil.
	self assert: subarchetype parent equals: archetype.
	self assert: subsubarchetype parent equals: subarchetype.
	
]

{ #category : #'tests compositions' }
TKTArchetypeCreationTestCase >> testArchetypePlusProjectPlusProjectGivesNewArchetypeDependancies [
	| archetype subarchetype subsubarchetype |
	archetype := TKTArchetype new.
	subarchetype := archetype + TKTProject new.
	subsubarchetype := subarchetype + TKTProject new.
	self assert: archetype parent isNil.
	self assert: subarchetype parent equals: archetype.
	self assert: subsubarchetype parent equals: subarchetype.
	self assert: archetype dependancies isEmpty.
	self assert: subarchetype dependancies size equals: 1.
	self assert: subsubarchetype dependancies size equals: 2
]

{ #category : #'test defaults' }
TKTArchetypeCreationTestCase >> testArchetypeThisImageHasOnlyName [ 
	| currentArchetype |
	currentArchetype := TKTArchetype thisImage.
	self assert: currentArchetype parent isNil.
	self assert: currentArchetype imageSelector isNil .
	self assert: currentArchetype vmSelector isNil.
	self assert: currentArchetype architectureSelector isNil.
	self assert: currentArchetype dependancies isEmpty.
	self assert: currentArchetype name equals: #thisImage.
]

{ #category : #'test defaults' }
TKTArchetypeCreationTestCase >> testMoose61ArchetypeHasPharo61ParentAndMooseProject [
	| currentArchetype |
	currentArchetype := TKTArchetype moose61.
	self assert: currentArchetype parent equals: TKTArchetype pharo61.
	self assert: currentArchetype imageSelector equals: '61'.
	self assert: currentArchetype vmSelector equals: #stable.
	self assert: currentArchetype architectureSelector equals: 64.
	self assert: currentArchetype dependancies size equals: 1.
	self
		assert: currentArchetype dependancies first
		equals: TKTProject moose
]

{ #category : #'test defaults' }
TKTArchetypeCreationTestCase >> testMoose70ArchetypeHasPharo70ParentAndMooseProject [
	| currentArchetype |
	currentArchetype := TKTArchetype moose70.
	self assert: currentArchetype parent equals: TKTArchetype pharo70.
	self assert: currentArchetype imageSelector equals: '70'.
	self assert: currentArchetype vmSelector equals: #stable.
	self assert: currentArchetype architectureSelector equals: 64.
	self assert: currentArchetype dependancies size equals: 1.
	self
		assert: currentArchetype dependancies first
		equals: TKTProject moose
]

{ #category : #'test defaults' }
TKTArchetypeCreationTestCase >> testMoose80ArchetypeHasPharo80ParentAndMooseProject [
	| currentArchetype |
	currentArchetype := TKTArchetype moose80.
	self assert: currentArchetype parent equals: TKTArchetype pharo80.
	self assert: currentArchetype imageSelector equals: '80'.
	self assert: currentArchetype vmSelector equals: #stable.
	self assert: currentArchetype architectureSelector equals: 64.
	self assert: currentArchetype dependancies size equals: 1.
	self
		assert: currentArchetype dependancies first
		equals: TKTProject moose
]
