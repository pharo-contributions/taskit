starting
stop
	watchDog ifNotNil: [ watchDog stop ].
	workers do: #stop.
	workers removeAll