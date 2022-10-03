Class {
	#name : #AlbTextEditorToElementHandler,
	#superclass : #BlCustomEventHandler,
	#instVars : [
		'element'
	],
	#category : #'Album-UI-Handlers'
}

{ #category : #accessing }
AlbTextEditorToElementHandler >> element [

	^ element
]

{ #category : #accessing }
AlbTextEditorToElementHandler >> element: anElement [

	element := anElement
]

{ #category : #'api - accessing' }
AlbTextEditorToElementHandler >> eventsToHandle [

	^ {  }
]
