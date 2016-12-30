initialization
initializeWithProcess: aProcess
	| stackCopy previousHolder |
	process := aProcess.
	stackCopy := thisContext copyStack stack.
	contextHolders := thisContext stack withIndexCollect: [ :context :index |
		TKTContextHolder
			forProcess: aProcess
			context: context
			andCopy: (stackCopy at: index)
			withIndex: index ].
	previousHolder := nil.
	contextHolders reverse do: [ :contextHolder |
		contextHolder next: previousHolder.
		previousHolder := contextHolder ]
	