"
Ston serialization is the default ston serializer with some extras, like support for clean blocks (which are transmitted as string representation and recompiled in the other endpoint), but it does not allow to transmit errors nor contexts. 
"
Class {
	#name : #TKTStonSerializationStrategy,
	#superclass : #TKTSerializationStrategy,
	#category : #'TaskItForkIt-Worker-Server'
}

{ #category : #writing }
TKTStonSerializationStrategy >> privateDecodeContent: aZnEntity [
	^ (STONReader on: aZnEntity string readStream) next
]

{ #category : #writing }
TKTStonSerializationStrategy >> privateEncodeContent: aContent [
	^ ZnEntity
		text:
			(String
				streamContents: [ :str | (STONWriter on: str) nextPut: aContent ])
]

{ #category : #writing }
TKTStonSerializationStrategy >> selector [
	^ #ston
]
