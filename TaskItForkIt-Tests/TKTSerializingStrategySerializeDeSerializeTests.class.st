Class {
	#name : #TKTSerializingStrategySerializeDeSerializeTests,
	#superclass : #ParametrizedTestCase,
	#instVars : [
		'selectorFrom',
		'selectorTo'
	],
	#category : #'TaskItForkIt-Tests'
}

{ #category : #tests }
TKTSerializingStrategySerializeDeSerializeTests class >> testParameters [
	^ ParametrizedTestMatrix new
		forSelector: #selectorFrom addOptions: {#ston . #fuel . #xstoned};
		forSelector: #selectorTo addOptions: {#ston . #fuel . #xstoned};
		yourself
]

{ #category : #tests }
TKTSerializingStrategySerializeDeSerializeTests >> selectorFrom: aSelector [
	selectorFrom := aSelector.
]

{ #category : #tests }
TKTSerializingStrategySerializeDeSerializeTests >> selectorTo: aSelector [
	selectorTo := aSelector.
]

{ #category : #tests }
TKTSerializingStrategySerializeDeSerializeTests >> testSerializedEntityCanBeDeserializedByAnserializer [
	| entity |
	entity := (TKTSerializationStrategy resolveSerializer: selectorFrom)
		writeZnEntityFor: 4.
	self
		assert:
			((TKTSerializationStrategy resolveSerializer: selectorTo)
				readFromZnEntity: entity)
		equals: 4
]
