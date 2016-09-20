#!/bin/bash 

set -ex

./pharo Pharo.image eval "

Metacello new 
	baseline: 'TaskIt';
	repository: 'filetree://.';
	load.
Metacello new 
	baseline: 'TaskItShell';
	repository: 'filetree://.';
	load.

Smalltalk snapshot: true andQuit: true.
"

