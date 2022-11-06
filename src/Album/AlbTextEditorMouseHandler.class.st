Class {
	#name : #AlbTextEditorMouseHandler,
	#superclass : #AlbEditorElementHandler,
	#category : #'Album-UI-Handlers'
}

{ #category : #'api - accessing' }
AlbTextEditorMouseHandler >> eventsToHandle [

	^ { BlMouseDownEvent }
]

{ #category : #'event handling' }
AlbTextEditorMouseHandler >> mouseDownEvent: anEvent [

	| aNavigator aScreenPosition editor aTextIndex |
	"To not create an instance of me for each tiny text element"

	anEvent consumed: true.
	aScreenPosition := (element
		                    localBoundsToMine: (BlBounds origin: anEvent localPosition extent: 0.0 @ 0.0)
		                    fromChild: anEvent currentTarget) center.
	editor := element editor.
	aNavigator := editor navigator.
	aTextIndex := aNavigator findTextIndexAtScreenPosition: aScreenPosition ifAbsent: [ nil ].

	anEvent modifiers isShift
		ifTrue: [ 
			aTextIndex ifNotNil: [ 
				(editor selection contains: aTextIndex)
					ifTrue: [ 
						editor deselecter
							from: aTextIndex to: editor selection indices last;
							deselect ]
					ifFalse: [ 
						editor selecter
							extendToIndex: aTextIndex;
							select ] ] ]
		ifFalse: [ 
			(element hasFocus ) ifTrue: [ 
				editor deselecter all deselect ] ].
	aNavigator moveToScreenPosition: aScreenPosition.
	element requestFocus.
	aNavigator apply.

	anEvent sendTo: element
]
