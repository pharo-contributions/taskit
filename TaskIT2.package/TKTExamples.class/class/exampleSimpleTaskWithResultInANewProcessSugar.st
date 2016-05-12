sugar - examples - builder - simple task - result
exampleSimpleTaskWithResultInANewProcessSugar
	<example>
	| result |
	result := (2 -> #yourself) tkt
		simpleTask;
		inALocalProcess;
		result.
	result inspect.
	self assert: result + 2 = 4