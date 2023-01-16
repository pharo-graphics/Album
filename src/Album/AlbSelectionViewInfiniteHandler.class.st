Class {
	#name : #AlbSelectionViewInfiniteHandler,
	#superclass : #AlbSelectionViewHandler,
	#category : #'Album-UI-Handlers'
}

{ #category : #'api - accessing' }
AlbSelectionViewInfiniteHandler >> blurEvent: anEvent [

	self selectionView onLostFocus 
]

{ #category : #'api - accessing' }
AlbSelectionViewInfiniteHandler >> elementScrolledEvent: anEvent [

	self selectionView selectionScrolled: anEvent delta in: self editorElement
]

{ #category : #'api - accessing' }
AlbSelectionViewInfiniteHandler >> eventsToHandle [

	^ { 
		  BlElementScrolledEvent.
		  BlBlurEvent.
		  BlFocusEvent }
]

{ #category : #'api - accessing' }
AlbSelectionViewInfiniteHandler >> focusEvent: anEvent [

	self selectionView onGotFocus 
]
