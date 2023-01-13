Class {
	#name : #AlbSelectionViewElementHandler,
	#superclass : #AlbSelectionViewHandler,
	#category : #'Album-UI-Handlers'
}

{ #category : #'api - accessing' }
AlbSelectionViewElementHandler >> elementExtentChangedEvent: anEvent [

	self selectionView extentChangedIn: anEvent currentTarget
]

{ #category : #'api - accessing' }
AlbSelectionViewElementHandler >> elementScrolledEvent: anEvent [

	self selectionView selectionScrolled: anEvent delta in: anEvent currentTarget
]

{ #category : #'api - accessing' }
AlbSelectionViewElementHandler >> eventsToHandle [

	^ { 
		  BlElementExtentChangedEvent.
		  BlElementScrolledEvent }
]
