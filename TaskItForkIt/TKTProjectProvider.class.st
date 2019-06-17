Class {
	#name : #TKTProjectProvider,
	#superclass : #TKTResourceProvider,
	#category : #'TaskItForkIt-ImageBuilding'
}

{ #category : #'resolving and install' }
TKTProjectProvider >> install: aProject at: aDeployed [
	aProject deployIn: aDeployed
]
