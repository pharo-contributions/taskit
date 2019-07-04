Class {
	#name : #TKTFileDeployerHasExpectedFolders,
	#superclass : #TestCase,
	#instVars : [
		'deployer'
	],
	#category : #'TaskItForkIt-Tests'
}

{ #category : #running }
TKTFileDeployerHasExpectedFolders >> baseFolder [
	^ Smalltalk imageFile parent resolve / 'pharo-local' / #forking
]

{ #category : #running }
TKTFileDeployerHasExpectedFolders >> setUp [ 
	super setUp. 
	deployer := TKTFileOrientedDeployer default.
	" This test is here just to ensure the respect of the directory architecture of the file deployer "
]

{ #category : #running }
TKTFileDeployerHasExpectedFolders >> testBaseFolder [
	self assert: deployer baseFolder fullName asFileReference  equals: self baseFolder
]

{ #category : #running }
TKTFileDeployerHasExpectedFolders >> testCurrentFolder [
	self assert: deployer currentCacheFolder fullName asFileReference  equals: self baseFolder /#current
]

{ #category : #running }
TKTFileDeployerHasExpectedFolders >> testDeployCache [
	self assert: deployer defaultDeployFolder fullName asFileReference   equals: self baseFolder /#deployCache
]

{ #category : #running }
TKTFileDeployerHasExpectedFolders >> testImageFolder [
	self assert: deployer imageFolder  fullName asFileReference equals: self baseFolder /#image
]

{ #category : #running }
TKTFileDeployerHasExpectedFolders >> testVmFolder [
	self assert: deployer vmFolder fullName asFileReference  equals: self baseFolder / #vm
]

{ #category : #running }
TKTFileDeployerHasExpectedFolders >> testWorkingDirectory [ 
	self assert: deployer workingDirectory fullName asFileReference  equals: Smalltalk imageFile parent resolve
]
