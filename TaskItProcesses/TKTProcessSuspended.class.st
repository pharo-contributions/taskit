"
Process finishing is an announcement that announce that the process has been suspended. 
	This announcement is called by the caller of this method. So the announcement mechanism will run into the thread of the caller.
"
Class {
	#name : #TKTProcessSuspended,
	#superclass : #TKTProcessAnnouncement,
	#category : 'TaskItProcesses'
}
