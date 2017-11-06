accessing
default
	| configuration |
	^ value
		ifNil: [ self inform: 'Runner!'.
			configuration := self profiles.
			value := (configuration at: (configuration at: #profile)) value.
			(value at: #initialize) value.
			value ]