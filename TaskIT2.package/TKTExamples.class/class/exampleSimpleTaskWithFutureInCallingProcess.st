examples - builder - simple task - future
exampleSimpleTaskWithFutureInCallingProcess
	<example>
	| builder future |
	builder := TKTBuilder new.
	future := builder
		simpleTask;
		send: #yourself;
		to: 2;
		inThisProcess;
		future.
	future inspect.
	self assert: future value + 2 = 4