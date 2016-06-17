private -execution
monitorAndFetchCommandOutput
	| errors output |
	[ self osProcessHasFinished ] whileFalse: [ (Delay forMilliseconds: 15) wait ].
	errors := stderr readStream upToEnd.
	output := stdout readStream upToEnd.
	stderr ensureDelete.
	stdout ensureDelete.
	osProcess succeeded
		ifFalse: [ self error: errors ].
	^ output