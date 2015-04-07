run
process: aBlock
	isProcessing := true.
	^ aBlock
		ensure: [ isProcessing := false ]