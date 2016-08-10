examples - builder - simple task - future
exampleSimpleTaskWithFutureInANewProcess
	<example>
	| builder future |
	builder := TKTBuilder new.
	future := builder
		simpleTask;
		send: #yourself;
		to: 2;
		inALocalProcess;
		future.
	future inspect.
	self assert: future value + 2 = 4