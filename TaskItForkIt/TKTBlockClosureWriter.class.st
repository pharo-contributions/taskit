"
This is just a simple hack for ston to support basic clean blocks.
"
Class {
	#name : #TKTBlockClosureWriter,
	#superclass : #Object,
	#instVars : [
		'string'
	],
	#category : #TaskItForkIt
}

{ #category : #'instance creation' }
TKTBlockClosureWriter class >> fromSton: stonReader [
	^ (super fromSton: stonReader) block
]

{ #category : #'instance creation' }
TKTBlockClosureWriter class >> ston: aBlockClosure on: stonWriter [
	aBlockClosure isClean
		ifFalse: [ stonWriter writeNull ]
		ifTrue: [ self new
				string: aBlockClosure asString;
				stonOn: stonWriter ]
]

{ #category : #'instance creation' }
TKTBlockClosureWriter >> block [
	^ self class evaluate: string
]

{ #category : #'instance creation' }
TKTBlockClosureWriter >> string: aStringRepresentation [
	string := aStringRepresentation
]
