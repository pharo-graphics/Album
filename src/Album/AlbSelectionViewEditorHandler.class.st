Class {
	#name : #AlbSelectionViewEditorHandler,
	#superclass : #AlbSelectionViewHandler,
	#instVars : [
		'editorElement'
	],
	#category : #'Album-UI-Handlers'
}

{ #category : #accessing }
AlbSelectionViewEditorHandler >> editorElement [

	^ editorElement
]

{ #category : #accessing }
AlbSelectionViewEditorHandler >> editorElement: anEditorElement [

	editorElement := anEditorElement
]

{ #category : #'api - accessing' }
AlbSelectionViewEditorHandler >> eventsToHandle [

	^ { 
		  AlbTextEditedEvent.
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

{ #category : #'api - accessing' }
AlbSelectionViewEditorHandler >> textEditedEvent: anEvent [

	self selectionView textEditedIn: self editorElement
]
