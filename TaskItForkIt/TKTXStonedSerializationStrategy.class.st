"
XStoned is an extention of ston. It has most of the restrictions of Ston, but, in the case of unknown classes, it generates on the fly, stubs with the content, allowing to interact with the objects as DTO. Only de state are transmitted. This allow to provide some minimal way to share data inbetween incompatible images.
"
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
