*TaskitRetry
collect: aBlock withRetry: aRetry

	^ (self collect: aBlock)
		recoverWith: [ :error |
			(error isKindOf: Halt)
				ifTrue: [ self halt ].
			aRetry isDone
				ifTrue: [ error pass ]
				ifFalse: [ 
					aRetry waitLapse.
					self collect: aBlock withRetry: aRetry next ] ]