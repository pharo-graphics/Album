"
I'm responsible for creating the cursor element in Album. I keep the current cursor so that it is instantiated one time for each AlbEditorElement.


Internal Representation and Key Implementation Points.

    Instance Variables
	blinkTask:		<AlbCursorBlinkingTask> to manage the blinking
	blinking:		<Boolean> true is the cursor must blink
	currentCursorElement:		<AlbCursorElement> the current cursor element


    Implementation Points
See the #create comment about the current instance variable



"
Class {
	#name : #AlbCursorStencil,
	#superclass : #OBlStencil,
	#instVars : [
		'blinking',
		'blinkTask',
		'currentCursorElement'
	],
	#category : #'Album-UI-Stencils'
}

{ #category : #accessing }
AlbCursorStencil >> beBlinking: aBoolean [

	blinking := aBoolean
]

{ #category : #'api - instantiation' }
AlbCursorStencil >> create [

	"Pay attention: a CursorElement ** must be a singleton **. 
	If not, dbl clicking will not work because the target of the first click may 
	be different from the one of the second click"

	currentCursorElement ifNotNil: [ 
		self startBlinkingTask.
		^ currentCursorElement ].
	currentCursorElement := AlbCursorElement new
		           constraintsDo: [ :c | 
			           c horizontal exact: 2.
			           c vertical matchParent];
		           yourself.
	self startBlinkingTask.
	^ currentCursorElement
]

{ #category : #accessing }
AlbCursorStencil >> currentCursorElement [

	^ currentCursorElement
]

{ #category : #initialization }
AlbCursorStencil >> initialize [
	super initialize.
	blinking := true
]

{ #category : #'api - instantiation' }
AlbCursorStencil >> newBlinkingTask [

	^ AlbCursorBlinkingTask new cursor: currentCursorElement
]

{ #category : #'api - instantiation' }
AlbCursorStencil >> startBlinkingTask [

	blinking ifFalse: [ ^ self ].

	blinkTask ifNotNil: [ 
		blinkTask stop.
		currentCursorElement dequeueTask: blinkTask ].

	currentCursorElement enqueueTask: (blinkTask := self newBlinkingTask)
]
