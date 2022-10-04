Class {
	#name : #AlbTextEditorSelectionHandler,
	#superclass : #AlbTextEditorToElementHandler,
	#instVars : [
		'startIndex'
	],
	#category : #'Album-UI-Handlers'
}

{ #category : #'event handling' }
AlbTextEditorSelectionHandler >> dragEndEvent: anEvent [

	anEvent consumed: true.

]

{ #category : #'event handling' }
AlbTextEditorSelectionHandler >> dragEvent: anEvent [

	| anEditor currentIndex from to |
	anEvent consumed: true.

	anEditor := anEvent currentTarget editor.

	currentIndex := anEditor navigator findTextIndexAtScreenPosition: anEvent localPosition ifAbsent: [ ^ self ].

	startIndex ifNil: [ startIndex := currentIndex ].

	from := startIndex min: currentIndex.
	to := startIndex max: currentIndex.

	anEditor selecter
		overwrite;
		from: from to: to;
		select.
]

{ #category : #'event handling' }
AlbTextEditorSelectionHandler >> dragStartEvent: anEvent [
	| anEditor |	
	anEvent consumed: true.

	anEditor := anEvent currentTarget editor.
	anEditor deselecter all deselect.
	
	startIndex := anEditor navigator
		findTextIndexAtScreenPosition: anEvent localPosition
		ifAbsent: [ nil ]
]

{ #category : #'api - accessing' }
AlbTextEditorSelectionHandler >> eventsToHandle [
	^ { BlDragEvent . BlDragStartEvent. BlDragEndEvent}
]
