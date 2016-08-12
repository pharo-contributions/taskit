tests
testFutureExecutesConcurrently

	| results future1 future2 |
	results := OrderedCollection new.

	future1 := [ 0.5 second wait.
	results add: 1 ] future.
	future2 := [ 0.1 seconds wait.
	results add: 2 ] future.
	
	future1 waitForCompletion: 2 seconds.
	future2 waitForCompletion: 2 seconds.
	
	self assert: results asArray equals: #(2 1)	