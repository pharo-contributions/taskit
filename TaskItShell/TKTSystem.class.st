Class {
	#name : #TKTSystem,
	#superclass : #Object,
	#category : #TaskItShell
}

{ #category : #'as yet unclassified' }
TKTSystem class >> chmod [
	^ '/bin/chmod' asFileReference command
]

{ #category : #'as yet unclassified' }
TKTSystem class >> cp [
	^ '/bin/cp' asFileReference command
]

{ #category : #'as yet unclassified' }
TKTSystem class >> grep [
	^ '/bin/grep' asFileReference command
]

{ #category : #'as yet unclassified' }
TKTSystem class >> ln [
	^ '/bin/ln' asFileReference command
]

{ #category : #'as yet unclassified' }
TKTSystem class >> ls [
	^ '/bin/ls' asFileReference command
]

{ #category : #'as yet unclassified' }
TKTSystem class >> mv [
	^ '/bin/mv' asFileReference command
]

{ #category : #'as yet unclassified' }
TKTSystem class >> rm [
	^ '/bin/rm' asFileReference command
]

{ #category : #'as yet unclassified' }
TKTSystem class >> unzip: aFileReference into: aDirectory [
	aDirectory ensureCreateDirectory.
	^ [ :spec | 
	spec
		command: 'unzip';
		option: '-d' value: aDirectory fullName;
		argument: aFileReference fullName ] asOSTask future 
]
