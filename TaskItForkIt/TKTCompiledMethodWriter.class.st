Class {
	#name : #TKTCompiledMethodWriter,
	#superclass : #Object,
	#instVars : [
		'methodClassName',
		'selector'
	],
	#category : #'TaskItForkIt-Xstoned'
}

{ #category : #'instance creation' }
TKTCompiledMethodWriter class >> fromSton: stonReader [
	^ (super fromSton: stonReader) method
]

{ #category : #'instance creation' }
TKTCompiledMethodWriter class >> ston: aCompiledMethod on: stonWriter [
	self new
		methodClassName: aCompiledMethod classBinding name;
		selector: aCompiledMethod selector;
		stonOn: stonWriter
]

{ #category : #accessing }
TKTCompiledMethodWriter >> method [
	^ methodClassName asClass compiledMethodAt: selector asSymbol
]

{ #category : #accessing }
TKTCompiledMethodWriter >> methodClassName: aString [
	methodClassName := aString
]

{ #category : #accessing }
TKTCompiledMethodWriter >> selector: aString [
	selector := aString
]
