as yet unclassified
processorsAndRunners
	| params p r |
	params := OrderedCollection new.
	p := TKTSameThreadProcessor new.
	r := TKTSimpleRunner on: p.
	params add: {r}.
	p := TKTCommonThreadProcessor new.
	r := TKTSimpleRunner on: p.
	params add: {r}.
	p := TKTDaemonThreadProcessor new.
	r := TKTSimpleRunner on: p.
	params add: {r}.
	p := TKTForkedProcessor new.
	r := TKTSimpleRunner on: p.
	params add: {r}.
	^ params asArray