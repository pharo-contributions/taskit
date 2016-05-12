testing messages
spinOnceWithParam: aParameter
	parameter := aParameter.
	200 milliSeconds wait.
	self logCr: 'lalala'