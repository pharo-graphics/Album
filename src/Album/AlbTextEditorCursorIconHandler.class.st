Class {
	#name : #AlbTextEditorCursorIconHandler,
	#superclass : #AlbEditorElementHandler,
	#category : #'Album-UI-Handlers'
}

{ #category : #'event handling' }
AlbTextEditorCursorIconHandler >> dragEnterEvent: anEvent [

	anEvent currentTarget mouseCursor: BlCursor default
]

{ #category : #'event handling' }
AlbTextEditorCursorIconHandler >> dragLeaveEvent: anEvent [

	anEvent currentTarget mouseCursor: BlCursor default
]

{ #category : #'api - accessing' }
AlbTextEditorCursorIconHandler >> eventsToHandle [
	^ {
		BlDragEnterEvent.
		BlDragLeaveEvent.
		BlMouseEnterEvent.
		BlMouseLeaveEvent.
		BlMouseOverEvent 
	}
]

{ #category : #'event handling' }
AlbTextEditorCursorIconHandler >> mouseEnterEvent: anEvent [

	anEvent currentTarget mouseCursor: BlCursor overEditableText
]

{ #category : #'event handling' }
AlbTextEditorCursorIconHandler >> mouseLeaveEvent: anEvent [

	anEvent currentTarget mouseCursor: BlCursor default
]

{ #category : #'event handling' }
AlbTextEditorCursorIconHandler >> mouseOverEvent: anEvent [

	anEvent currentTarget mouseCursor: BlCursor overEditableText
]

{ #category : #'api - event managing' }
AlbTextEditorCursorIconHandler >> wantsEvent: anEvent [

	element allowSelection ifFalse: [ ^ false ].
	^ super wantsEvent: anEvent
]
