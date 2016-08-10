as yet unclassified
testSizeIsNeverBiggerThan2
	1 to: 20 do: [ :i | 
		self assert: queue size <= 2.
		queue nextPut: i ]