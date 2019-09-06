Class {
	#name : #TKTSerializingStrategyResolvingTests,
	#superclass : #ParametrizedTestCase,
	#instVars : [
		'selector'
	],
	#category : #'TaskItForkIt-Tests'
}

{ #category : #tests }
TKTSerializingStrategyResolvingTests class >> testParameters [
	^ ParametrizedTestMatrix new
		forSelector: #selector addOptions: {#ston . #fuel . #xstoned};
		yourself
]

{ #category : #tests }
TKTSerializingStrategyResolvingTests >> selector: aSelector [
	selector := aSelector.
]

{ #category : #tests }
TKTSerializingStrategyResolvingTests >> testResolvedSerializerRespondsToSelector [
	self
		assert: (TKTSerializationStrategy resolveSerializer: selector) selector
		equals: selector
]
