accessing
optionAt: aKey value: aValue during: aBlock
	| copy |
	copy := self value copy.
	copy at: aKey put: aValue.
	^ self value: copy during: aBlock