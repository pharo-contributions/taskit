callbacks
invoke: callbacks
	callbacks
		do: [ :cb | 
			[ cb cull: value ]
				on: Error
				do: [ :e | errors add: e ] ].
	self invokeErrors: errorCallbacks