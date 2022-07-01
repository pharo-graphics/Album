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

{ #category : #'mouse handlers' }
AlbTextEditorDoubleClickHandler >> doubleClickEvent: anEvent [

	| screenPosition globalTextIndex selecter editorElement navigator editor selection  |
	"To not create an instance of me for each tiny text element"
	editorElement := anEvent currentTarget
		                 withAllParentsDetect: [ :anElement | 
		                 anElement isKindOf: AlbEditorElement ]
		                 ifFound: #yourself
		                 ifNone: [ ^ self ].

	screenPosition := (editorElement
		                   localBoundsToMine:
		                   (BlBounds
			                    origin: anEvent localPosition
			                    extent: 0.0 @ 0.0)
		                   fromChild: anEvent currentTarget) center.

	editor := editorElement editor.
	navigator := editor navigator.
	selecter := editor selecter.

	globalTextIndex := navigator
		                   findTextIndexAtScreenPosition: screenPosition
		                   ifAbsent: [ ^ self ].


	(globalTextIndex isZero or: [ globalTextIndex = editor text size ]) 
		ifTrue: [ 
			selecter
				all;
				apply.
			^ self ].

	selection := selecter selection.

	"Try to select between delimiters () [] etc"
	editor surroundMap
		intervalBetweenDelimitersIn: editor text
		at: globalTextIndex
		ifPresent: [ :interval | 
			selecter
				from: interval first to: interval last;
				apply.
			^ self ]
		ifAbsent: [].

	" try to select the whole line "
	editorElement cursor ifNotNil: [ :globalCursor |
		| delta lineIdx |
		lineIdx := navigator findTextIndexAtLineStart: globalCursor.
		delta := lineIdx - globalTextIndex.
		delta isZero ifTrue: [ 
			selecter
				extendToWholeLine;
				apply.
			^ self ].
		lineIdx := navigator findTextIndexAtLineEnd: globalCursor.
		delta := globalTextIndex - lineIdx.
		delta isZero ifTrue: [ 
			selecter
				extendToWholeLine;
				apply.
			^ self ] ].

	anEvent modifiers isPrimaryModifier ifTrue: [ 
		selecter withoutCursorUpdate ].

	selecter
		wordAt: globalTextIndex;
		apply.
	
]

{ #category : #accessing }
AlbTextEditorDoubleClickHandler >> eventsToHandle [
	^ { BlDoubleClickEvent }
]

{ #category : #accessing }
AlbTextEditorDoubleClickHandler >> wantsEvent: anEvent [
	^ (super wantsEvent: anEvent) and: [ anEvent primaryButtonPressed ]
]
