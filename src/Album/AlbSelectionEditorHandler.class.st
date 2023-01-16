Class {
	#name : #AlbSelectionEditorHandler,
	#superclass : #AlbSelectionHandler,
	#category : #'Album-UI-Handlers'
}

{ #category : #'api - accessing' }
AlbSelectionEditorHandler >> eventsToHandle [

	^ { 
		  AlbSelectionChangedEvent.
		  AlbRemanentUpdateRequest }
]

{ #category : #'api - accessing' }
AlbSelectionEditorHandler >> remanentUpdateRequest: anEvent [

	self selectionElement setRemanentsIn: self editorElement 

]

{ #category : #'api - accessing' }
AlbSelectionEditorHandler >> selectionChangedEvent: anEvent [

	self selectionElement selectionChangedIn: self editorElement
]
