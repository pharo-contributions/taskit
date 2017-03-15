private
filteredSlaveStack
	"skip process creation context"
	| firstInterestingContext |
	firstInterestingContext := interruptedContext stack
		detect: [ :ctxt |
			ctxt notNil and: [
				(ctxt receiver isKindOf: TKTTask) and: [
					ctxt selector = #value ] ] ]
		ifNone: [  ^ interruptedContext stack allButLast ].
		
	^ interruptedContext stack copyUpTo: firstInterestingContext