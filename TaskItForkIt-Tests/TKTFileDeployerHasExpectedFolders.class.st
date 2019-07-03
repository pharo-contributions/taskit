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
	self assert: deployer baseFolder equals: self baseFolder
]

{ #category : #running }
TKTFileDeployerHasExpectedFolders >> testCurrentFolder [
	self assert: deployer currentCacheFolder equals: self baseFolder /#current
]

{ #category : #running }
TKTFileDeployerHasExpectedFolders >> testDeployCache [
	self assert: deployer defaultDeployFolder  equals: self baseFolder /#deployCache
]

{ #category : #running }
TKTFileDeployerHasExpectedFolders >> testImageFolder [
	self assert: deployer imageFolder  equals: self baseFolder /#image
]

{ #category : #running }
TKTFileDeployerHasExpectedFolders >> testVmFolder [
	self assert: deployer vmFolder equals: self baseFolder / #vm
]

{ #category : #running }
TKTFileDeployerHasExpectedFolders >> testWorkingDirectory [ 
	self assert: deployer workingDirectory equals: Smalltalk imageFile parent resolve
]
