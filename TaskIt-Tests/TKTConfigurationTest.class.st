Class {
	#name : 'TKTConfigurationTest',
	#superclass : 'TKTTestCase',
	#category : 'TaskIt-Tests-Kernel',
	#package : 'TaskIt-Tests',
	#tag : 'Kernel'
}

{ #category : 'tests' }
TKTConfigurationTest >> testAllProfilesCanBeSet [
	TKTProfile profiles do: [ :each |
		| aProfile |
		aProfile := each value value.
		TKTConfiguration profile: aProfile.
		self assert: TKTConfiguration profile == aProfile ].
	self deny: TKTProfile profiles isEmpty.

	
]

{ #category : 'tests' }
TKTConfigurationTest >> testDefaultValueIsAProfile [
	TKTConfiguration resetSoleInstance.
	self assert: (TKTConfiguration profile isKindOf: TKTProfile).
]
