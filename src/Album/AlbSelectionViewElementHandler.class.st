Class {
	#name : #AlbSelectionViewElementHandler,
	#superclass : #AlbSelectionViewHandler,
	#category : #'Album-UI-Handlers'
}

{ #category : #'api - accessing' }
AlbSelectionViewElementHandler >> elementExtentChangedEvent: anEvent [

	self selectionView extentChangedIn: self editorElement
]

{ #category : #'api - accessing' }
AlbSelectionViewElementHandler >> eventsToHandle [

	^ { BlElementExtentChangedEvent }
]
