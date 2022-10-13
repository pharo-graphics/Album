Class {
	#name : #AlbTextEditorMouseHandler,
	#superclass : #AlbEditorElementHandler,
	#category : #'Album-UI-Handlers'
}

{ #category : #'event handling' }
AlbTextEditorMouseHandler >> clickEvent: anEvent [

	anEvent consumed: true
]

{ #category : #'api - accessing' }
AlbTextEditorMouseHandler >> eventsToHandle [

	^ { 
		  BlMouseDownEvent.
		  BlMouseUpEvent.
		  BlClickEvent }
]

{ #category : #'event handling' }
AlbTextEditorMouseHandler >> mouseDownEvent: anEvent [

	| aNavigator aScreenPosition spacePosition textInputPosition |
	"To not create an instance of me for each tiny text element"
	anEvent consumed: true.
	aScreenPosition := (element
		                    localBoundsToMine: (BlBounds origin: anEvent localPosition extent: 0.0 @ 0.0)
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
	element startTextInputAtRectangle: (textInputPosition corner: (textInputPosition translateBy: 2 @ 20)).
	element startTextInput
]

{ #category : #'event handling' }
AlbTextEditorMouseHandler >> mouseUpEvent: anEvent [

	anEvent consumed: true
]

{ #category : #'event handling' }
AlbTextEditorMouseHandler >> wantsEvent: anEvent [
	element allowSelection ifFalse: [  ^ false ].
	^ (super wantsEvent: anEvent) and: [ anEvent primaryButtonPressed ]
]
