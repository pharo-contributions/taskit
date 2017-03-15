examples
exampleFailure
	<example>
	self enable.

	[ Object blah ] future onFailureDo: [ :ex | ex debug ]