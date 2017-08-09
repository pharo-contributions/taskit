private
filteredMasterStack
	| masterHolder entryPointHolder |
	masterHolder := interruptedProcess masterProcessHolder.
	entryPointHolder := masterHolder findContextHolderSuchThat: [ :contextHolder |
		contextHolder originalContext selector = #future and: [
			contextHolder originalContext receiver isKindOf: TKTTask ] ].
	entryPointHolder := (entryPointHolder notNil and: [
		entryPointHolder next originalContext receiver class = BlockClosure and: [
			entryPointHolder next originalContext selector = #future ] ])
				ifTrue: [ entryPointHolder next ]
				ifFalse: [ entryPointHolder ].
	^ entryPointHolder
		ifNil: [ masterHolder stack ]
		ifNotNil: [ masterHolder stackStartingAt: entryPointHolder next ]