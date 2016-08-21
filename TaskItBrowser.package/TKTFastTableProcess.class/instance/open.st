instance creation
open
	window := self manager openInWindowLabeled: 'TaskIT 2.0 Process dashboard'.
	window on: WindowClosed send: #cleanUpSources to: self.
	window bounds: (Rectangle origin: 100@100 corner: Display extent /2). 
	self manager addTab: self taskItProcessesTable.
	self manager addTab: self systemProcessesTable