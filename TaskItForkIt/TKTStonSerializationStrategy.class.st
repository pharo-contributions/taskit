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
