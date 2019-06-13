Class {
	#name : #TKTProjectProvider,
	#superclass : #TKTResourceProvider,
	#category : #TaskItForkIt
}

{ #category : #'resolving and install' }
TKTProjectProvider >> install: aProject at: aDeployed [
	aProject deployIn: aDeployed
]
