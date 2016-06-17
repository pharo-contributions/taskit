accessing
interpreter
	^ interpreter ifNil: [ interpreter := ExternalUnixOSProcess defaultShellPath ]