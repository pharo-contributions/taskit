Class {
	#name : #TKTArchetype,
	#superclass : #Object,
	#instVars : [
		'name',
		'imageSelector',
		'vmSelector',
		'architectureSelector',
		'isHeadless',
		'dependencies',
		'deleteOnQuit',
		'quitOnFinalization'
	],
	#category : #TaskItForkIt
}

{ #category : #shortcuts }
TKTArchetype class >> currentArchitecture [
	^ (Smalltalk image sourceFileVersionString
		indexOfSubCollection: '32bit') > 0
		ifTrue: [ 32 ]
		ifFalse: [ 64 ]
]

{ #category : #shortcuts }
TKTArchetype class >> pharo70 [
	^ self new
		imageSelector: '70';
		architectureSelector: 32;
		vmSelector: #stable
]

{ #category : #shortcuts }
TKTArchetype class >> pharo80 [
	^ self new
		imageSelector: '80';
		architectureSelector: 64;
		vmSelector: #stable
]

{ #category : #shortcuts }
TKTArchetype class >> pharoCurrent [
	^ self new
		imageSelector: 'current';
		vmSelector: #current;
		architectureSelector: self currentArchitecture;
		yourself
]

{ #category : #accessing }
TKTArchetype >> architectureSelector [
	^ architectureSelector
]

{ #category : #accessing }
TKTArchetype >> architectureSelector: aSelector [
	 architectureSelector := aSelector
]

{ #category : #accessing }
TKTArchetype >> deleteOnQuit [
	^ deleteOnQuit ifNil: [ deleteOnQuit := true ]
]

{ #category : #accessing }
TKTArchetype >> dependancies [
	^  dependencies
]

{ #category : #accessing }
TKTArchetype >> dependsOn: aTKTProject [
	dependencies add: aTKTProject  
]

{ #category : #accessing }
TKTArchetype >> dependsOnBaselineOf: name version: aVersion repository: aRepository [
	self
		dependsOn:
			(TKTProject new
				name: name;
				kind: #BaselineOf;
				version: aVersion;
				repository: aRepository;
				yourself)
]

{ #category : #accessing }
TKTArchetype >> dependsOnConfigurationOf: name version: aVersion repository: aRepository [
	self
		dependsOn:
			(TKTProject new
				name: name;
				kind: #ConfigurationOf;
				version: aVersion;
				repository: aRepository;
				yourself)
]

{ #category : #accessing }
TKTArchetype >> deploy [
	^ TKTDeployer default
		deploy: self
		at:
			((#/ asFileReference / #tmp / self name / UUID new asString)
				ensureCreateDirectory;
				yourself)
]

{ #category : #accessing }
TKTArchetype >> headless: aFalse [
	isHeadless := aFalse
]

{ #category : #accessing }
TKTArchetype >> imageSelector [
	^ imageSelector 
]

{ #category : #accessing }
TKTArchetype >> imageSelector: aSelector [
	imageSelector := aSelector
]

{ #category : #accessing }
TKTArchetype >> initialize [ 
	super initialize .
	dependencies := OrderedCollection new
]

{ #category : #accessing }
TKTArchetype >> isHeadless [
	^ isHeadless ifNil: [ isHeadless := true ]
]

{ #category : #accessing }
TKTArchetype >> name [
	^ name ifNil: [ name := imageSelector ,'vm', vmSelector  ]
]

{ #category : #accessing }
TKTArchetype >> name: aName [
	name := aName
]

{ #category : #accessing }
TKTArchetype >> quitOnFinalization [
	^ quitOnFinalization ifNil: [ quitOnFinalization := true ]
]

{ #category : #accessing }
TKTArchetype >> version [
	| selector |
	selector := imageSelector asString.
	selector = #current
		ifTrue: [ selector := SystemVersion current major asString
				, SystemVersion current minor asString ].
	^ 'Pharo{1}.{2}-{3}bit'
		format:
			{selector first.
			selector second.
			architectureSelector asString}
]

{ #category : #accessing }
TKTArchetype >> vmSelector [
	^ vmSelector
]

{ #category : #accessing }
TKTArchetype >> vmSelector: aSelector [
	 vmSelector := aSelector
]
