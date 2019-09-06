"
In forkit the archetype is a really simple description of an image to build. 

It is defined in terms of image selector (the version of the image, for the default providers), vm selector (the version of the vm, for the default providers) and architecture selector (32/64 bits, for the default providers).

An archetype hierarchy is available for reusing definitions. The very first archetype should define a functional image, and the rest of the childs, project's specialization.
"
Class {
	#name : #TKTArchetype,
	#superclass : #Object,
	#traits : 'TEquality',
	#classTraits : 'TEquality classTrait',
	#instVars : [
		'name',
		'imageSelector',
		'vmSelector',
		'architectureSelector',
		'dependencies',
		'parent'
	],
	#classInstVars : [
		'lightweight'
	],
	#category : #'TaskItArchetype-Archetype'
}

{ #category : #accessing }
TKTArchetype class >> currentArchitecture [
	^ (Smalltalk image sourceFileVersionString
		indexOfSubCollection: '32bit') > 0
		ifTrue: [ 32 ]
		ifFalse: [ 64 ]
]

{ #category : #accessing }
TKTArchetype class >> instVarNamesForEqualityComparison [
	^ self instVarNames asOrderedCollection
		remove: #name;
		yourself
]

{ #category : #accessing }
TKTArchetype class >> lightweight [
	^ lightweight ifNil: [ lightweight := Dictionary new ]
]

{ #category : #moose }
TKTArchetype class >> moose61 [
	^ self lightweight
		at: #moose61
		ifAbsentPut: [ self pharo61 + TKTProject moose ]
]

{ #category : #moose }
TKTArchetype class >> moose70 [
	^ self lightweight
		at: #moose70
		ifAbsentPut: [ self pharo70 + TKTProject moose ]
]

{ #category : #moose }
TKTArchetype class >> moose80 [
	^ self lightweight
		at: #moose80
		ifAbsentPut: [ self pharo80 + TKTProject moose ]
]

{ #category : #moose }
TKTArchetype class >> mooseCurrent [
	^ self lightweight
		at: #mooseCurrent
		ifAbsentPut: [ self pharoCurrent + TKTProject moose ]
]

{ #category : #instantiating }
TKTArchetype class >> named: aTag imageSelector: imageSelector architectureSelector: archectureSelector vmSelector: vmSelector [
	^ self lightweight
		at: aTag
		ifAbsentPut: [ self new
				name: aTag;
				imageSelector: imageSelector;
				architectureSelector: archectureSelector;
				vmSelector: vmSelector ]
]

{ #category : #pharo }
TKTArchetype class >> pharo61 [
	^ self
		named: #pharo61
		imageSelector: '61'
		architectureSelector: 64
		vmSelector: #stable
]

{ #category : #'pharo 32' }
TKTArchetype class >> pharo6132Bits [
	^ self
		named: #pharo6132Bits
		imageSelector: '61'
		architectureSelector: 32
		vmSelector: #stable
]

{ #category : #pharo }
TKTArchetype class >> pharo70 [
	^ self
		named: #pharo70
		imageSelector: '70'
		architectureSelector: 64
		vmSelector: #stable
]

{ #category : #'pharo 32' }
TKTArchetype class >> pharo7032Bits [
	^ self
		named: #pharo7032Bits
		imageSelector: '70'
		architectureSelector: 32
		vmSelector: #stable
]

{ #category : #pharo }
TKTArchetype class >> pharo80 [
	^ self
		named: #pharo80
		imageSelector: '80'
		architectureSelector: 64
		vmSelector: #stable
]

{ #category : #'pharo 32' }
TKTArchetype class >> pharo8032Bits [
	^ self
		named: #pharo8032Bits
		imageSelector: '80'
		architectureSelector: 32
		vmSelector: #stable
]

{ #category : #pharo }
TKTArchetype class >> pharoCurrent [
	^ self
		named: #pharoCurrent
		imageSelector: 'current'
		architectureSelector: self currentArchitecture
		vmSelector: #current
]

{ #category : #'this image' }
TKTArchetype class >> thisImage [
	^ self
		named: #thisImage
		imageSelector: nil
		architectureSelector: nil
		vmSelector: nil
]

{ #category : #accessing }
TKTArchetype >> + aProject [
	^ self copy 
		parent: self;
		name: nil;
		dependsOn: aProject;
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
TKTArchetype >> compatibleWith: anArchetype [
	^ self = anArchetype or: [ self parent = anArchetype ]
]

{ #category : #accessing }
TKTArchetype >> configureBackend: aBackend [
	aBackend archetype: self.
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
TKTArchetype >> dependsOnBaselineOf: aName repository: aRepository [
	self
		dependsOn:
			(TKTProject new
				name: aName;
				kind: #BaselineOf;
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
	^ TKTFileOrientedDeployer default deployAtDefaultLocation: self
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
	dependencies := OrderedCollection new.

]

{ #category : #accessing }
TKTArchetype >> isCurrentPharo [
	^ imageSelector = #current
]

{ #category : #accessing }
TKTArchetype >> isDeploy [
	^ false
]

{ #category : #accessing }
TKTArchetype >> name [
	^ name
		ifNil: [ parent
				ifNil: [ name := imageSelector , 'vm' , vmSelector ]
				ifNotNil: [ name := dependencies
						inject: parent name
						into: [ :bn :each | bn , each name ] ] ]
]

{ #category : #accessing }
TKTArchetype >> name: aName [
	name := aName
]

{ #category : #acceesing }
TKTArchetype >> parent [
	^ parent
]

{ #category : #accessing }
TKTArchetype >> parent: aParent [
	parent := aParent
]

{ #category : #accessing }
TKTArchetype >> postCopy [
	dependencies := dependencies copy.
]

{ #category : #accessing }
TKTArchetype >> printOn: stream [
	stream nextPutAll: 'Archetype(' , self version , ')'
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
