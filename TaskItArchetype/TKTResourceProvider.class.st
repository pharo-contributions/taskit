"
A resoruce provider is in charge of resolving the selectors into URLs for downloading and installing.
It works as a hook for resolving differently the dependancies 
"
Class {
	#name : #TKTResourceProvider,
	#superclass : #Object,
	#category : #'TaskItArchetype-Deployer'
}

{ #category : #intalling }
TKTResourceProvider >> installProject: aTKTProject at: aTKTDeployed using: aTKTDeployer [
	^ aTKTProject deployIn: aTKTDeployed using: aTKTDeployer
]

{ #category : #resolving }
TKTResourceProvider >> resolvePharoBundle: vmVersion forImage: imageVersion architecture: anArchitecture using: aDeployer [
	^ imageVersion = #current
		ifTrue: [ #current ]
		ifFalse: [ ('http://files.pharo.org/get-files/{1}/pharo{2}.zip'
				format:
					{imageVersion asString.
					(anArchitecture = 32
						ifTrue: [ '' ]
						ifFalse: [ anArchitecture asString ])}) asZnUrl ]
]

{ #category : #intalling }
TKTResourceProvider >> resolveVM: vmVersion forImage: imageVersion architecture: anInteger using: aDeployer [
	vmVersion = #current
		ifTrue: [ ^ #current ].
	^ ('http://files.pharo.org/get-files/{1}/pharo{2}-{3}-{4}.zip'
		format:
			{imageVersion asString.
			(anInteger = 32
				ifTrue: [ '' ]
				ifFalse: [ anInteger ]) asString.
			aDeployer platformName.
			vmVersion}) asZnUrl
]
