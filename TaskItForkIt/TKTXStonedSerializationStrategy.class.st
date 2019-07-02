Class {
	#name : #TKTXStonedSerializationStrategy,
	#superclass : #TKTSerializationStrategy,
	#category : #'TaskItForkIt-Worker-Server'
}

{ #category : #writing }
TKTXStonedSerializationStrategy >> privateDecodeContent: aZnEntity [
	^ (TKTXSTONedReader on: aZnEntity string readStream) next
]

{ #category : #writing }
TKTXStonedSerializationStrategy >> privateEncodeContent: aContent [
	^ ZnEntity
		text:
			(String
				streamContents: [ :str | (STONWriter on: str) nextPut: aContent ])
]

{ #category : #writing }
TKTXStonedSerializationStrategy >> selector [
	^ #xstoned
]
