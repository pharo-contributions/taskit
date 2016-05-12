as yet unclassified
testValueIsAlwaysTheNewer
	1 to: 20 do: [ :i | queue nextPut: i ].
	self assert: queue next equals: 19.
	self assert: queue next equals: 20.