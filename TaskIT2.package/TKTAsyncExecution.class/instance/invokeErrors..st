callbacks
invokeErrors: callbacks
	errors isNotEmpty
		ifTrue: [ callbacks do: [ :cb | cb value: errors ] ]