Class {
	#name : #AlbTextEditorDoubleClickHandler,
	#superclass : #BlCustomEventHandler,
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'Album-UI-Handlers'
}

{ #category : #accessing }
AlbTextEditorDoubleClickHandler class >> cleanUp [
	super cleanUp.
	
	uniqueInstance := nil
]

{ #category : #accessing }
AlbTextEditorDoubleClickHandler class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
]

{ #category : #'as yet unclassified' }
AlbTextEditorDoubleClickHandler >> doubleClickEvent: anEvent [
	| aScreenPosition aGlobalTextIndex aSelecter anEditorElement |
	
	"To not create an instance of me for each tiny text element"
	anEditorElement := anEvent currentTarget
		withAllParentsDetect: [ :anElement | (anElement isKindOf: BrEditorElement) or: [anElement isKindOf: AlbEditorElement]]
		ifFound: #yourself
		ifNone: [ ^ self ].
		
	aScreenPosition := (anEditorElement localBoundsToMine: (BlBounds origin: anEvent localPosition extent: 0.0@0.0) fromChild: anEvent currentTarget) center.

	aGlobalTextIndex := anEditorElement editor navigator
		findTextIndexAtScreenPosition: aScreenPosition
		ifAbsent: [ ^ self ].
	
	aSelecter := anEditorElement editor selecter.

	anEvent modifiers isPrimaryModifier
		ifTrue: [ aSelecter withoutCursorUpdate ].

	aSelecter
		wordAt: aGlobalTextIndex;
		select
]

{ #category : #accessing }
AlbTextEditorDoubleClickHandler >> eventsToHandle [
	^ { BlDoubleClickEvent }
]

{ #category : #accessing }
AlbTextEditorDoubleClickHandler >> wantsEvent: anEvent [
	^ (super wantsEvent: anEvent) and: [ anEvent primaryButtonPressed ]
]
