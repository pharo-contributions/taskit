building
commandPath
	command asFileReference exists
		ifTrue: [ ^ command ].
	^ ((':' split: (OSEnvironment current at: 'PATH')) collect: #asFileReference thenSelect: #exists) first fullName