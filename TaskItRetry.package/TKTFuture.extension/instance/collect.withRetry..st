*TaskitRetry
collect: aBlock withRetry: aRetry

	^ (self collect: aBlock)
		recoverWith: [ :error |
			aRetry isDone
				ifTrue: [ error pass ]
				ifFalse: [ 
					aRetry waitLapse.
					self collect: aBlock withRetry: aRetry next ] ]