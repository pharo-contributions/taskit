Class {
	#name : #TKTSerializationStrategy,
	#superclass : #Object,
	#category : #'TaskItForkIt-Worker-Server'
}

{ #category : #'as yet unclassified' }
TKTSerializationStrategy class >> default [ 
	^ self ston
]

{ #category : #'as yet unclassified' }
TKTSerializationStrategy class >> fuel [
	^ TKTFuelSerializationStrategy new
]

{ #category : #'as yet unclassified' }
TKTSerializationStrategy class >> resolveSerializer: aName [
	aName = #fuel ifTrue: [ ^ self fuel ].
	aName = #ston ifTrue: [ ^ self ston ].
	aName = #xstoned ifTrue: [ ^ self xstoned ].
]

{ #category : #'as yet unclassified' }
TKTSerializationStrategy class >> ston [ 
	^ TKTStonSerializationStrategy new
]

{ #category : #'as yet unclassified' }
TKTSerializationStrategy class >> xstoned [ 
	^ TKTXStonedSerializationStrategy new
]

{ #category : #writing }
TKTSerializationStrategy >> privateDecodeContent: aZnEntity [
	self subclassResponsibility 
]

{ #category : #writing }
TKTSerializationStrategy >> privateEncodeContent: aContent [
	self subclassResponsibility 
]

{ #category : #writing }
TKTSerializationStrategy >> readFromZnEntity: aRequestEntity [
	^ (self class
		resolveSerializer: (aRequestEntity partNamed: 'serializer') fieldValue)
		privateDecodeContent: (aRequestEntity partNamed: 'content') entity
]

{ #category : #writing }
TKTSerializationStrategy >> readFromZnRequest: aRequestEntity [
	((aRequestEntity isKindOf: ZnResponse ) and:[aRequestEntity isError])
		ifTrue: [ self error: ' REMOTE ERROR: ' , aRequestEntity entity string ].
	^ aRequestEntity entity
		ifNotNil: [ self readFromZnEntity: aRequestEntity entity ]
]

{ #category : #writing }
TKTSerializationStrategy >> selector [
	self subclassResponsibility 
]

{ #category : #writing }
TKTSerializationStrategy >> serializerFor: aRequestEntity [
	^ aRequestEntity
		ifNil: [ self class default ]
		ifNotNil: [ self class
				resolveSerializer: (aRequestEntity partNamed: 'serializer') fieldValue ]
]

{ #category : #writing }
TKTSerializationStrategy >> writeZnEntityFor: aValue [
	^ ZnMultiPartFormDataEntity new
		addPart: (ZnMimePart fieldName: 'serializer' value: self selector);
		addPart:
			(ZnMimePart
				fieldName: 'content'
				entity: (self privateEncodeContent: aValue));
		yourself
]
