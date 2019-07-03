Class {
	#name : #TKTProviderGivesValidUrls,
	#superclass : #ParametrizedTestCase,
	#instVars : [
		'provider',
		'vmVersion',
		'imageVersion',
		'anArchitecture',
		'platformName'
	],
	#category : #'TaskItForkIt-Tests'
}

{ #category : #'building suites' }
TKTProviderGivesValidUrls class >> testParameters [
	^ ParametrizedTestMatrix new
		forSelector: #vmVersion
			addOptions: {#stable . #latest};
		forSelector: #imageVersion
			addOptions: {61 . 70 . 80 };
		forSelector: #anArchitecture addOptions: {32 . 64};
		forSelector: #platformName addOptions: {#linux . #win . #mac};
		yourself
]

{ #category : #accessing }
TKTProviderGivesValidUrls >> anArchitecture [
	^ anArchitecture
]

{ #category : #accessing }
TKTProviderGivesValidUrls >> anArchitecture: anObject [
	anArchitecture := anObject
]

{ #category : #accessing }
TKTProviderGivesValidUrls >> imageVersion [
	^ imageVersion
]

{ #category : #accessing }
TKTProviderGivesValidUrls >> imageVersion: anObject [
	imageVersion := anObject
]

{ #category : #accessing }
TKTProviderGivesValidUrls >> platformName [
	^ platformName
]

{ #category : #accessing }
TKTProviderGivesValidUrls >> platformName: anObject [
	platformName := anObject
]

{ #category : #running }
TKTProviderGivesValidUrls >> setUp [
	super setUp.
	provider := TKTResourceProvider new
]

{ #category : #running }
TKTProviderGivesValidUrls >> testPharoBundleUrl [
	| url |
	url := provider
		resolvePharoBundle: vmVersion
		forImage: imageVersion
		architecture: anArchitecture
		using: self.
	self
		assert: url
		equals:
			('http://files.pharo.org/get-files/{1}/pharo{2}.zip'
				format:
					{imageVersion asString.
					(anArchitecture = 32
						ifTrue: [ '' ]
						ifFalse: [ anArchitecture asString ])}) asZnUrl
]

{ #category : #running }
TKTProviderGivesValidUrls >> testPharoVmUrl [
	| url |
	url := provider
		resolveVM: vmVersion
		forImage: imageVersion
		architecture: anArchitecture
		using: self.
	self
		assert: url
		equals:
			('http://files.pharo.org/get-files/{1}/pharo{2}-{3}-{4}.zip'
				format:
					{imageVersion asString.
					(anArchitecture = 32
						ifTrue: [ '' ]
						ifFalse: [ anArchitecture ]) asString.
					platformName.
					vmVersion}) asZnUrl
]

{ #category : #accessing }
TKTProviderGivesValidUrls >> vmVersion [
	^ vmVersion
]

{ #category : #accessing }
TKTProviderGivesValidUrls >> vmVersion: anObject [
	vmVersion := anObject
]
