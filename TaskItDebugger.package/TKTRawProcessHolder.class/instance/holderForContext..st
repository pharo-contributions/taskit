query
holderForContext: aContext
	^ self findContextHolderSuchThat: [ :contextHolder |
		contextHolder originalContext == aContext or: [
			contextHolder copyContext == aContext ] ]