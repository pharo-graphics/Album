Class {
	#name : #AlbSelectionViewEditorHandler,
	#superclass : #AlbSelectionViewHandler,
	#category : #'Album-UI-Handlers'
}

{ #category : #'api - accessing' }
AlbSelectionViewEditorHandler >> eventsToHandle [

	^ { 
		  AlbSelectionChangedEvent.
		  AlbRemanentUpdateRequest }
]

{ #category : #'api - accessing' }
AlbSelectionViewEditorHandler >> remanentUpdateRequest: anEvent [

	self selectionView setRemanentsIn: self editorElement 

]

{ #category : #'api - accessing' }
AlbSelectionViewEditorHandler >> selectionChangedEvent: anEvent [

	self selectionView selectionChangedIn: self editorElement
]
