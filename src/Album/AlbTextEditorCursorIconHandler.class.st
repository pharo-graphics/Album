Class {
	#name : #AlbTextEditorCursorIconHandler,
	#superclass : #BlCustomEventHandler,
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'Album-UI-Handlers'
}

{ #category : #accessing }
AlbTextEditorCursorIconHandler class >> cleanUp [
	uniqueInstance := nil
]

{ #category : #accessing }
AlbTextEditorCursorIconHandler class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
]

{ #category : #'api - event managing' }
AlbTextEditorCursorIconHandler >> dragEnterEvent: anEvent [
	anEvent currentTarget mouseCursor: BlCursor default
]

{ #category : #'api - event managing' }
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

{ #category : #'api - event managing' }
AlbTextEditorCursorIconHandler >> mouseEnterEvent: anEvent [
	anEvent currentTarget mouseCursor: BlCursor overEditableText
]

{ #category : #'api - event managing' }
AlbTextEditorCursorIconHandler >> mouseLeaveEvent: anEvent [
	anEvent currentTarget mouseCursor: BlCursor default
]

{ #category : #'api - event managing' }
AlbTextEditorCursorIconHandler >> mouseOverEvent: anEvent [
	anEvent currentTarget mouseCursor: BlCursor overEditableText
]
