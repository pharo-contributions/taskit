converting
asResult
	^ result ifNil: [ result := TKTLazyResult for: self ] ifNotNil: [ result ]