sugar - examples - builder - simple task - future
exampleSimpleTaskWithFutureInCallingProcessSugar
	<example>
	| future |
	future := (2 -> #yourself) tkt
		simpleTask;
		inThisProcess;
		future.
	future inspect.
	self assert: future value + 2 = 4