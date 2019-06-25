Class {
	#name : #TKTProviderDelegatesOnDeployerTests,
	#superclass : #ParametrizedTestCase,
	#instVars : [
		'deployer',
		'provider'
	],
	#category : #'TaskItForkIt-ImageBuilding'
}

{ #category : #'building suites' }
TKTProviderDelegatesOnDeployerTests class >> testParameters [
	^ ParametrizedTestMatrix new
		forSelector: #provider
			addOptions: (TKTResourceProvider allSubclasses collect: #new);
		yourself
]

{ #category : #accessing }
TKTProviderDelegatesOnDeployerTests >> provider: aProvider [
	provider := aProvider 
]

{ #category : #accessing }
TKTProviderDelegatesOnDeployerTests >> setUp [
	super setUp.
	deployer := TKTFileOrientedDeployer default.
]

{ #category : #accessing }
TKTProviderDelegatesOnDeployerTests >> testDeployerDefaultWorkignDirectoryIsImageDirectory [
	self
		assert: deployer workingDirectory
		equals: FileLocator workingDirectory
]

{ #category : #accessing }
TKTProviderDelegatesOnDeployerTests >> testProviderDefaultCurrentCacheDirectoryIsInDefaultWorkingDirectoryPlusPath [
	self
		assert: deployer currentCacheFolder
		equals: FileLocator workingDirectory / 'pharo-local' / #forking / #current
]

{ #category : #accessing }
TKTProviderDelegatesOnDeployerTests >> testProviderDefaultDeployFolderDirectoryIsInDefaultWorkingDirectoryPlusPath [
	self
		assert: deployer defaultDeployFolder
		equals: FileLocator workingDirectory / 'pharo-local' / #forking / #deployCache
]
