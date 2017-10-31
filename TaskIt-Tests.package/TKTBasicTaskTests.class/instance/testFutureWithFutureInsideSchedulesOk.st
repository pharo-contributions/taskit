tests
testFutureWithFutureInsideSchedulesOk

	| future |

	future := [ [TKTConfiguration runner] schedule ] future.

	self shouldnt: (future synchronizeTimeout: 1 second) raise: UnhandledError.