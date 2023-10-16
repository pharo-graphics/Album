"
I'm a simple task that manage cursor blinking.

"
Class {
	#name : 'AlbCursorBlinkingTask',
	#superclass : 'BlRepeatedTask',
	#instVars : [
		'cursor'
	],
	#category : 'Album-UI',
	#package : 'Album',
	#tag : 'UI'
}

{ #category : 'accessing' }
AlbCursorBlinkingTask >> cursor: aCursorElement [
	cursor := aCursorElement
]

{ #category : 'initialization' }
AlbCursorBlinkingTask >> defaultBlinkingDelay [ 

	^ 600 milliSeconds 
]

{ #category : 'initialization' }
AlbCursorBlinkingTask >> initialize [
	super initialize.
	self delay: self defaultBlinkingDelay 
]

{ #category : 'api - running' }
AlbCursorBlinkingTask >> onRun [

	cursor visibility: (cursor visibility isHidden
			 ifTrue: [ BlVisibility visible ]
			 ifFalse: [ BlVisibility hidden ])
]

{ #category : 'api - running' }
AlbCursorBlinkingTask >> stop [
	super stop.
	cursor visibility: BlVisibility visible 
]
