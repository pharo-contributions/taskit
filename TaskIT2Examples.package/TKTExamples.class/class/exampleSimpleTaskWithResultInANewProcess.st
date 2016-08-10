examples - builder - simple task - result
exampleSimpleTaskWithResultInANewProcess
	<example>
	| builder result |
	builder := TKTBuilder new.
	result := builder
		simpleTask;
		send: #yourself;
		to: 2;
		inALocalProcess;
		result.
	result inspect.
	self assert: result + 2 = 4