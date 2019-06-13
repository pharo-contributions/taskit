"
In forkit the archetype is a really simple description of an image to build. 

It is defined in terms of image selector (the version of the image, for the default providers), vm selector (the version of the vm, for the default providers) and architecture selector (32/64 bits, for the default providers).

An archetype hierarchy is available for reusing definitions. The very first archetype should define a functional image, and the rest of the childs, project's specialization.
"
Class {
	#name : #TKTArchetype,
	#superclass : #Object,
	#instVars : [
		'name',
		'imageSelector',
		'vmSelector',
		'architectureSelector',
		'dependencies',
		'parent'
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
TKTArchetype class >> moose61 [
	^ self pharo61
		+
			(TKTProject moose
				repository: 'github://impetuosa/Moose:development';
				yourself)
]

{ #category : #shortcuts }
TKTArchetype class >> moose70 [
	^ self pharo70
		+
			(TKTProject moose
				repository: 'github://impetuosa/Moose:development';
				yourself)
]

{ #category : #shortcuts }
TKTArchetype class >> moose80 [
	^ self pharo80
		+
			(TKTProject moose
				repository: 'github://impetuosa/Moose:development';
				yourself)
]

{ #category : #shortcuts }
TKTArchetype class >> mooseCurrent [
	^ self pharoCurrent
		+
			(TKTProject moose
				repository: 'github://impetuosa/Moose:development';
				yourself)
]

{ #category : #shortcuts }
TKTArchetype class >> pharo61 [
	^ self new
		imageSelector: '61';
		architectureSelector: 64;
		vmSelector: #stable
]

{ #category : #shortcuts }
TKTArchetype class >> pharo6132Bits [
	^ self new
		imageSelector: '61';
		architectureSelector: 32;
		vmSelector: #stable
]

{ #category : #shortcuts }
TKTArchetype class >> pharo70 [
	^ self new
		imageSelector: '70';
		architectureSelector: 64;
		vmSelector: #stable
]

{ #category : #shortcuts }
TKTArchetype class >> pharo7032Bits [
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
TKTArchetype class >> pharo8032Bits [
	^ self new
		imageSelector: '80';
		architectureSelector: 32;
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
TKTArchetype >> + aProject [
	^ self copy 
		parent: self;
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
	^ TKTArchetypeProvider default installOnDefaultLocation: self
]

{ #category : #accessing }
TKTArchetype >> deployDirect [
	^ TKTDeployer default
		deploy: self
		at:
			(('pharo-local' asFileReference / #forking / #deployCache / self name
				/ UUID new asString)
				ensureCreateDirectory;
				yourself)
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
TKTArchetype >> name [
	^ name ifNil: [ 
		parent ifNil: [ name := imageSelector ,'vm', vmSelector ] ifNotNil: [
			name := dependencies inject: parent name into: [ :bn : each | bn , each archetypeName  ]
		]. 
		    ]
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
