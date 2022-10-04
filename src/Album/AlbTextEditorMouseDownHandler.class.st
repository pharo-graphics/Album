Class {
	#name : #AlbTextEditorMouseDownHandler,
	#superclass : #AlbTextEditorToElementHandler,
	#category : #'Album-UI-Handlers'
}

{ #category : #'api - accessing' }
AlbTextEditorMouseDownHandler >> eventsToHandle [
	^ { BlMouseDownEvent }
]

{ #category : #'event handling' }
AlbTextEditorMouseDownHandler >> mouseDownEvent: anEvent [

	| aNavigator aScreenPosition spacePosition textInputPosition |
	"To not create an instance of me for each tiny text element"

	anEvent target
		withAllParentsUpTo: element
		detect: [ :anElement | 
			anElement userData at: #editorAdornment ifAbsent: [ false ] ]
		ifFound: [ :anAdornmentElement | ^ self ]
		ifNone: #yourself.

	anEvent consumed: true.
	aScreenPosition := (element
		                    localBoundsToMine:
		                    (BlBounds
			                     origin: anEvent localPosition
			                     extent: 0.0 @ 0.0)
		                    fromChild: anEvent currentTarget) center.

	element editor deselecter all deselect.

	aNavigator := element editor navigator.
	aNavigator moveToScreenPosition: aScreenPosition.
	aNavigator apply.

	"it is important to request focus *after* we add a cursor, otherwise it would jump to the 0 position when
	handling focus event"
	element requestFocus.
	anEvent sendTo: element.
	self flag: 'low level text input managing. Should be revised to use the right screen position'.
	spacePosition := element space position.
	textInputPosition := aScreenPosition. "spacePosition + " "+ (12@25)"
	element startTextInputAtRectangle:
		(textInputPosition corner: (textInputPosition translateBy: 2 @ 20)).
	element startTextInput
]

{ #category : #'event handling' }
AlbTextEditorMouseDownHandler >> wantsEvent: anEvent [
	^ (super wantsEvent: anEvent) and: [ anEvent primaryButtonPressed ]
]
