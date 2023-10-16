Class {
	#name : 'AlbTextEditorDoubleClickHandler',
	#superclass : 'AlbEditorElementHandler',
	#category : 'Album-UI-Handlers',
	#package : 'Album',
	#tag : 'UI-Handlers'
}

{ #category : 'event handling' }
AlbTextEditorDoubleClickHandler >> doubleClickEvent: anEvent [

	| screenPosition globalTextIndex selecter navigator editor selection |
	anEvent isConsumed ifTrue: [ ^ self ].
	anEvent consumed: true.
	screenPosition := (element
		                   localBoundsToMine: (BlBounds origin: anEvent localPosition extent: 0.0 @ 0.0)
		                   fromChild: element) center.

	editor := element editor.
	navigator := editor navigator.
	selecter := editor selecter.

	globalTextIndex := navigator findTextIndexAtScreenPosition: screenPosition ifAbsent: [ ^ self ].


	(globalTextIndex isZero or: [ globalTextIndex = editor privateText size ]) ifTrue: [
		selecter
			all;
			apply.		
		^ self ].

	selection := selecter selection.

	"Try to select between delimiters () [] etc"
	editor surroundMap
		intervalBetweenDelimitersIn: editor privateText
		at: globalTextIndex
		ifPresent: [ :interval |
			selecter
				from: interval first to: interval last;
				apply.
			^ self ]
		ifAbsent: [  ].

	" try to select the whole line "
	element cursor ifNotNil: [ :globalCursor |
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

	anEvent modifiers isPrimaryModifier ifTrue: [ selecter withoutCursorUpdate ].

	selecter
		wordAt: globalTextIndex;
		apply
]

{ #category : 'api - accessing' }
AlbTextEditorDoubleClickHandler >> eventsToHandle [

	^ { BlDoubleClickEvent }
]
