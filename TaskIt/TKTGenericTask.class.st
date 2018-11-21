"
I am a generic task that can be created from a valuable
"
Class {
	#name : #TKTGenericTask,
	#superclass : #TKTTask,
	#instVars : [
		'valuable'
	],
	#category : 'TaskIt-Kernel'
}

{ #category : #accessing }
TKTGenericTask >> valuable [
	^ valuable
]

{ #category : #accessing }
TKTGenericTask >> valuable: aValuable [
	valuable := aValuable
]

{ #category : #executing }
TKTGenericTask >> value [

	^ valuable value
]
