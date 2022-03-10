Class {
	#name : #AlbTextEditorMouseDownHandler,
	#superclass : #BlCustomEventHandler,
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'Album-Editor-UI - Handlers'
}

{ #category : #cleanup }
AlbTextEditorMouseDownHandler class >> cleanUp [
	super cleanUp.
	
	uniqueInstance := nil
]

{ #category : #cleanup }
AlbTextEditorMouseDownHandler class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
]

{ #category : #'api - accessing' }
AlbTextEditorMouseDownHandler >> eventsToHandle [
	^ { BlMouseDownEvent }
]

{ #category : #'as yet unclassified' }
AlbTextEditorMouseDownHandler >> mouseDownEvent: anEvent [
	| aNavigator aScreenPosition anEditorElement |
	
	"To not create an instance of me for each tiny text element"
	anEditorElement := anEvent currentTarget
		withAllParentsDetect: [ :anElement | (anElement isKindOf: BrEditorElement) or: [anElement isKindOf: AlbEditorElement] ]
		ifFound: #yourself
		ifNone: [ ^ self ].

	anEvent target
		withAllParentsUpTo: anEditorElement
		detect: [ :anElement | anElement userData at: #brickEditorAdornment ifAbsent: [ false ] ]
		ifFound:  [ :anAdornmentElement | ^ self ]
		ifNone: #yourself.

	anEvent consumed: true.
	aScreenPosition := (anEditorElement localBoundsToMine: (BlBounds origin: anEvent localPosition extent: 0.0@0.0) fromChild: anEvent currentTarget) center.
	
	anEditorElement editor deselecter all deselect.
	
	aNavigator := anEditorElement editor navigator.
	anEvent modifiers isPrimaryModifier
		ifTrue: [ aNavigator addAtScreenPosition: aScreenPosition ]
		ifFalse: [ aNavigator moveToScreenPosition: aScreenPosition ].
	aNavigator apply.

	"it is important to request focus *after* we add a cursor, otherwise it would jump to the 0 position when
	handling focus event"
	anEditorElement requestFocus
]

{ #category : #'api - event managing' }
AlbTextEditorMouseDownHandler >> wantsEvent: anEvent [
	^ (super wantsEvent: anEvent) and: [ anEvent primaryButtonPressed ]
]
