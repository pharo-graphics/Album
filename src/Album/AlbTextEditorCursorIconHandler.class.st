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
element isEditable traceCr.
	anEvent currentTarget mouseCursor: (element isEditable
			 ifTrue: [ BlCursor overEditableText ]
			 ifFalse: [ BlCursor default ])
]

{ #category : #'event handling' }
AlbTextEditorCursorIconHandler >> mouseLeaveEvent: anEvent [

	anEvent currentTarget mouseCursor: BlCursor default
]

{ #category : #'event handling' }
AlbTextEditorCursorIconHandler >> mouseOverEvent: anEvent [

	anEvent currentTarget mouseCursor: BlCursor overEditableText
]
