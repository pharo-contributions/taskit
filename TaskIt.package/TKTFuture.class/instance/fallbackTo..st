combinators
fallbackTo: aFallbackFuture 
	
	^ self recoverWith: [ :error | aFallbackFuture ]