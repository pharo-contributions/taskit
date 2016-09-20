*TaskitRetry
collect: aBlock withRetry: aRetry

	^ (self collect: aBlock)
		recoverWith: [ :error |
			aRetry isDone
				ifTrue: [ self error: 'Error after retrying!'"error pass" ]
				ifFalse: [ 
					aRetry waitLapse.
					self collect: aBlock withRetry: aRetry next ] ]