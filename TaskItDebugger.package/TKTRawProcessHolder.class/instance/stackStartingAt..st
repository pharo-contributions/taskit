query
stackStartingAt: aContextHolder
	| stack isSuspended |
	(aContextHolder isNil or: [
		aContextHolder index >= contextHolders size ]) ifTrue: [ ^ #() ].

	"Include all live contexts (only when the process has been suspended)
	so that actions on live contexts can be performed on that context
	immediately without the need to lookup the equivalent context."
	isSuspended := self process isSuspended.
	stack := OrderedCollection new.
	contextHolders
		from: aContextHolder index
		to: contextHolders size
		do: [ :contextHolder |
			stack add: ((isSuspended not or: [
				contextHolder isDead ])
					ifTrue: [ contextHolder copyContext ]
					ifFalse: [ contextHolder originalContext ]) ].

	^ self process isTaskItRawProcess
		ifFalse: [ stack ]
		ifTrue: [ stack, self process masterProcessHolder stack ]