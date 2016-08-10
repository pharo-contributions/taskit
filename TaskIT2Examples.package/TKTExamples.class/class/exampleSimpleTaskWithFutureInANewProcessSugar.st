sugar - examples - builder - simple task - future
exampleSimpleTaskWithFutureInANewProcessSugar
	<example>
	| future |
	future := (2 -> #yourself) tkt
		simpleTask;
		inALocalProcess;
		future.
	future inspect.
	self assert: future value + 2 = 4