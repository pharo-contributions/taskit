accessing
default
	| configuration value |
	configuration := self profiles.
	value := (configuration at: (configuration at: #profile)) value.
	(value at: #initialize) value.
	^ value