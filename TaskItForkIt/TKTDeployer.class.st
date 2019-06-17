Class {
	#name : #TKTDeployer,
	#superclass : #Object,
	#instVars : [
		'imageProvider',
		'vmProvider',
		'sourceProvider',
		'projectsProvider'
	],
	#category : #'TaskItForkIt-ImageBuilding'
}

{ #category : #accessing }
TKTDeployer class >> default [
	^ self new
		imageProvider: TKTImageProvider new;
		vmProvider: TKTVMProvider new;
		projectsProvider: TKTProjectProvider new;
		sourceFileProvider: TKTSourceProvider new;
		yourself
]

{ #category : #accessing }
TKTDeployer >> deploy: anArchetype at: location [
	| deployed |
	vmProvider
		install: anArchetype vmSelector
		forImage: anArchetype imageSelector
		architecture: anArchetype architectureSelector
		at: location.
	imageProvider
		install: anArchetype imageSelector
		architecture: anArchetype architectureSelector
		at: location.
	sourceProvider
		install: anArchetype imageSelector
		architecture: anArchetype architectureSelector
		at: location.
	deployed := TKTDeployed new
		initializeWithLocation: location andArchetype: anArchetype;
		yourself.
	self updateDeployed: deployed.
	^ deployed
]

{ #category : #accessing }
TKTDeployer >> imageProvider [
	^ imageProvider
]

{ #category : #accessing }
TKTDeployer >> imageProvider: aForkItCopyImageProvider [
	imageProvider := aForkItCopyImageProvider
]

{ #category : #accessing }
TKTDeployer >> projectsProvider [
	^ projectsProvider
]

{ #category : #accessing }
TKTDeployer >> projectsProvider: aProjectProvider [
	projectsProvider := aProjectProvider
]

{ #category : #accessing }
TKTDeployer >> sourceFileProvider [
	^ sourceProvider
		ifNil: [ sourceProvider := imageProvider sourceFileProvider ]
]

{ #category : #accessing }
TKTDeployer >> sourceFileProvider: aForkItSameSrcProvider [
	sourceProvider := aForkItSameSrcProvider
]

{ #category : #accessing }
TKTDeployer >> updateDeployed: aDeployed [
	aDeployed archetype dependancies
		do: [ :d | projectsProvider install: d at: aDeployed ]
]

{ #category : #accessing }
TKTDeployer >> vmProvider [
	^ vmProvider
]

{ #category : #accessing }
TKTDeployer >> vmProvider: aForkItSameVMProvider [
	vmProvider := aForkItSameVMProvider
]
