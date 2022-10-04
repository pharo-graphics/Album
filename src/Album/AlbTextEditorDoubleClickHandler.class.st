Class {
	#name : #AlbTextEditorDoubleClickHandler,
	#superclass : #AlbTextEditorToElementHandler,
	#category : #'Album-UI-Handlers'
}

{ #category : #'event handling' }
AlbTextEditorDoubleClickHandler >> doubleClickEvent: anEvent [

	"To not create an instance of me for each tiny text element"
	self handleSelectionFromEvent: anEvent editorElement: element.
	anEvent sendTo: element
	
]

{ #category : #accessing }
AlbTextEditorDoubleClickHandler >> eventsToHandle [
	^ { BlDoubleClickEvent }
]

{ #category : #'event handling' }
AlbTextEditorDoubleClickHandler >> handleSelectionFromEvent: anEvent editorElement: anEditorElement [

	| screenPosition globalTextIndex selecter navigator editor selection  |
	"To not create an instance of me for each tiny text element"
	screenPosition := (anEditorElement
		                   localBoundsToMine:
		                   (BlBounds
			                    origin: anEvent localPosition
			                    extent: 0.0 @ 0.0)
		                   fromChild: anEvent currentTarget) center.

	editor := anEditorElement editor.
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
	anEditorElement cursor ifNotNil: [ :globalCursor |
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
AlbTextEditorDoubleClickHandler >> wantsEvent: anEvent [
	^ (super wantsEvent: anEvent) and: [ anEvent primaryButtonPressed ]
]
