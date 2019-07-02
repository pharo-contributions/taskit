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
