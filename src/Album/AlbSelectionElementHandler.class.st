Class {
	#name : #AlbSelectionElementHandler,
	#superclass : #AlbSelectionHandler,
	#category : #'Album-UI-Handlers'
}

{ #category : #'api - accessing' }
AlbSelectionElementHandler >> elementExtentChangedEvent: anEvent [

	self selectionElement extentChangedIn: self editorElement
]

{ #category : #'api - accessing' }
AlbSelectionElementHandler >> eventsToHandle [

	^ { BlElementExtentChangedEvent }
]
