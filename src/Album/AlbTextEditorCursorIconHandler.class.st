Class {
	#name : #AlbTextEditorCursorIconHandler,
	#superclass : #AlbEditorElementHandler,
	#category : #'Album-UI-Handlers'
}

{ #category : #'event handling' }
AlbTextEditorCursorIconHandler >> dragEnterEvent: anEvent [

	anEvent currentTarget mouseCursor: Cursor normal
]

{ #category : #'event handling' }
AlbTextEditorCursorIconHandler >> dragLeaveEvent: anEvent [

	anEvent currentTarget mouseCursor: Cursor normal
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

	anEvent currentTarget mouseCursor: (element isEditable
			 ifTrue: [ Cursor overEditableText ]
			 ifFalse: [ Cursor normal ])
]

{ #category : #'event handling' }
AlbTextEditorCursorIconHandler >> mouseLeaveEvent: anEvent [

	anEvent currentTarget mouseCursor: Cursor normal
]

{ #category : #'event handling' }
AlbTextEditorCursorIconHandler >> mouseOverEvent: anEvent [

	anEvent currentTarget mouseCursor: Cursor overEditableText
]
