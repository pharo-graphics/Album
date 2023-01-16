Class {
	#name : #AlbSelectionInfiniteHandler,
	#superclass : #AlbSelectionHandler,
	#category : #'Album-UI-Handlers'
}

{ #category : #'api - accessing' }
AlbSelectionInfiniteHandler >> blurEvent: anEvent [

	self selectionElement onLostFocusIn: self editorElement 
]

{ #category : #'api - accessing' }
AlbSelectionInfiniteHandler >> elementScrolledEvent: anEvent [

	self selectionElement selectionScrolled: anEvent delta in: self editorElement
]

{ #category : #'api - accessing' }
AlbSelectionInfiniteHandler >> eventsToHandle [

	^ { 
		  BlElementScrolledEvent.
		  BlBlurEvent.
		  BlFocusEvent }
]

{ #category : #'api - accessing' }
AlbSelectionInfiniteHandler >> focusEvent: anEvent [

	self selectionElement onGotFocusIn: self editorElement 
]
