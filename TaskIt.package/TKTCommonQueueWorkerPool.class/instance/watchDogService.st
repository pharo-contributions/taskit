initialization
watchDogService
	[ self watchDog.
	1 seconds wait ]
		on: Error
		do: [ :err | self inform: 'BLAAAAAAA'. self halt ].
 