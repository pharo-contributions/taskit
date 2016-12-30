examples
exampleFailure
	<example>
	| holder |
	self enable.

	holder := TKTRawProcessHolder for: Processor activeProcess.
	[
		Processor activeProcess masterProcessHolder: holder.
		Object blah ] future onFailureDo: [ :ex | ex debug ]