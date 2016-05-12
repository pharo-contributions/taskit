sugar - examples - builder - simple task - result
exampleSimpleTaskWithResultInCallingProcessSugar
	<example>
	| result |
	result := (2 -> #yourself) tkt
		simpleTask;
		inThisProcess;
		result.
	result inspect.
	self assert: result + 2 = 4