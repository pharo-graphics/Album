Class {
	#name : #AlbTextEditorSelectionHandler,
	#superclass : #AlbEditorElementHandler,
	#instVars : [
		'startIndex'
	],
	#category : #'Album-UI-Handlers'
}

{ #category : #'event handling' }
AlbTextEditorSelectionHandler >> dragEndEvent: anEvent [

	anEvent consume.
	element isEnabled ifFalse: [ ^ self ].

	element selectionChanged

]

{ #category : #'event handling' }
AlbTextEditorSelectionHandler >> dragEvent: anEvent [

	| anEditor currentIndex from to |
	anEvent consume.
	element isEnabled ifFalse: [ ^ self ].

	anEditor := element editor.
	currentIndex := anEditor navigator findTextIndexAtScreenPosition: anEvent localPosition ifAbsent: [ ^ self ].

	startIndex ifNil: [ startIndex := currentIndex ].

	from := startIndex min: currentIndex.
	to := startIndex max: currentIndex.

	anEditor selecter
		overwrite;
		from: from to: to;
		select.
	element selectionChanged
]

{ #category : #'event handling' }
AlbTextEditorSelectionHandler >> dragStartEvent: anEvent [
	| anEditor |	
	anEvent consume.
	element isEnabled ifFalse: [ ^ self ].

	anEditor := element editor.
	anEditor deselecter all deselect.
	
	startIndex := anEditor navigator
		findTextIndexAtScreenPosition: anEvent localPosition
		ifAbsent: [ nil ].
	element selectionChanged
]

{ #category : #'api - accessing' }
AlbTextEditorSelectionHandler >> eventsToHandle [

	^ {
		  BlDragEvent.
		  BlDragStartEvent.
		  BlDragEndEvent }
]
