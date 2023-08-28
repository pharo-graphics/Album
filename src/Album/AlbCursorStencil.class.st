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
	#superclass : #BlStencil,
	#instVars : [
		'currentCursorElement',
		'cursorColor'
	],
	#category : #'Album-UI-Stencils'
}

{ #category : #'api - instantiation' }
AlbCursorStencil >> create [
	"Pay attention: a CursorElement ** must be a singleton **. 
	If not, dbl clicking will not work because the target of the first click may 
	be different from the one of the second click"

	currentCursorElement ifNotNil: [
		^ currentCursorElement startBlinkingTask ].
	^ currentCursorElement := AlbCursorElement new
		                          background: self cursorColor;
		                          startBlinkingTask;
		                          yourself
]

{ #category : #accessing }
AlbCursorStencil >> currentCursorElement [

	^ currentCursorElement
]

{ #category : #accessing }
AlbCursorStencil >> cursorColor [

	^ cursorColor
]

{ #category : #accessing }
AlbCursorStencil >> cursorColor: aColor [

	cursorColor := aColor.
	currentCursorElement := nil
]

{ #category : #initialization }
AlbCursorStencil >> initialize [ 

	super initialize.
	cursorColor := Color red
]
