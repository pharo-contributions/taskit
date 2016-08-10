examples - builder - simple task - result
exampleSimpleTaskWithResultInCallingProcess
	<example>
	| builder result |
	builder := TKTBuilder new.
	result := builder
		simpleTask;
		send: #yourself;
		to: 2;
		inThisProcess;
		result.
	result inspect.
	self assert: result + 2 = 4