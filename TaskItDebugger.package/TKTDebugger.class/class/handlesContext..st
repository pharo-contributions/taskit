testing
handlesContext: aContext
	^ aContext callChainAnySatisfy: [ :ctxt |
		ctxt receiver class = TKTProcess ]