building
commandPath
	command asFileReference exists
		ifTrue: [ ^ command ].
	^ ((':' split: (OSEnvironment current at: 'PATH')) collect: [ :p | p asFileReference / command ] thenSelect: #exists) first fullName