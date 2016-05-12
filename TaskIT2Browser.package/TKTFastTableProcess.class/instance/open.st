instance creation
open
	window := self manager openInWindowLabeled: 'TaskIT 2.0 Process dashboard'.
	window maximize.
	window extent: window extent / 2.
	window on: WindowClosed send: #cleanUpSources to: self.
	
	self manager addTab: self taskItProcessesTable.
	self manager addTab: self systemProcessesTable