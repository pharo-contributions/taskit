accessing
default
	| configuration |
	^ value
		ifNil: [ 
			configuration := self profiles.
			value := (configuration at: (configuration at: #profile)) value.
			(value at: #initialize) value 
		]