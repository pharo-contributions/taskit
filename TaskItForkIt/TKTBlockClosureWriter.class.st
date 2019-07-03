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
TKTBlockClosureWriter class >> on: aBlockClosure [
	aBlockClosure isClean
		ifFalse: [ ^ self error: 'Only clean closures are supported ' ].
	^ self new
		string: aBlockClosure asString;
		yourself
]

{ #category : #'instance creation' }
TKTBlockClosureWriter >> block [
	^ self class evaluate: string
]

{ #category : #'instance creation' }
TKTBlockClosureWriter >> string: aStringRepresentation [
	string := aStringRepresentation
]
