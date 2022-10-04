Class {
	#name : #AlbTextEditorHandler,
	#superclass : #BlCustomEventHandler,
	#instVars : [
		'element'
	],
	#category : #'Album-UI-Handlers'
}

{ #category : #accessing }
AlbTextEditorHandler >> element [

	^ element
]

{ #category : #accessing }
AlbTextEditorHandler >> element: anElement [

	element := anElement
]

{ #category : #'api - accessing' }
AlbTextEditorHandler >> eventsToHandle [

	^ {  }
]
