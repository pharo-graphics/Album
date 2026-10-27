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
	anEvent primaryButtonPressed ifFalse: [ ^ self ].

	anEvent consume.
	aScreenPosition := (element
		                    localBoundsToMine:
		                    (BlBounds
			                     origin: anEvent localPosition
			                     extent: 0.0 @ 0.0)
		                    fromChild: anEvent currentTarget) center.
	editor := element editor.
	aNavigator := editor navigator.
	aTextIndex := aNavigator
		              findTextIndexAtScreenPosition: aScreenPosition
		              ifAbsent: [ nil ].

	"Alt (Option on macOS) click toggles an additional cursor"
	(anEvent modifiers isAlt and: [ aTextIndex notNil and: [ element isEditable ] ]) ifTrue: [
		editor deselecter all deselect.
		(editor cursors anySatisfy: [ :each | each position = aTextIndex ])
			ifTrue: [ aNavigator removeCursorAt: aTextIndex ]
			ifFalse: [ aNavigator addCursorAt: aTextIndex ].
		element requestFocus.
		aNavigator apply.
		^ self ].
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
			(element hasFocus or: [ element isEditable not ]) ifTrue: [
				editor deselecter all deselect ] ].
	aNavigator moveToScreenPosition: aScreenPosition.
	(element isEnabled and: [ element isEditable ]) ifTrue: [
		element requestFocus.
		anEvent consume ].
	aNavigator apply.
	anEvent sendTo: element
]
