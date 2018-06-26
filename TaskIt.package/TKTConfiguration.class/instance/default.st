accessing
default
	| configuration |
	^ value
		ifNil: [ configuration := self class profiles.
			value := (configuration at: (configuration at: #profile)) value.
			(value at: #initialize) value.
			value ]