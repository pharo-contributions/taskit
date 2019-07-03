"
Fuel serializer uses FUEL as serialization. 
Yo should, any way, to consider the Fuel errors on version management. (If the serialized object has different version of class or method, it will fail).
Do also have in account that classes that do not exist in the receiving endpoint, will trigger also errors, since classes are not transmitted.

"
Class {
	#name : #TKTFuelSerializationStrategy,
	#superclass : #TKTSerializationStrategy,
	#category : #'TaskItForkIt-Worker-Server'
}

{ #category : #writing }
TKTFuelSerializationStrategy >> privateDecodeContent: aZnEntity [

	^ FLMaterializer materializeFromByteArray: aZnEntity bytes
]

{ #category : #'as yet unclassified' }
TKTFuelSerializationStrategy >> privateEncodeContent: aContent [
	^ ZnEntity
		bytes:
			(ByteArray
				streamContents: [ :str | FLSerializer serialize: aContent on: str ])
]

{ #category : #writing }
TKTFuelSerializationStrategy >> selector [
	^ #fuel
]
