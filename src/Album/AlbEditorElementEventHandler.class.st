Class {
	#name : #AlbEditorElementEventHandler,
	#superclass : #BlCustomEventHandler,
	#category : #'Album-UI'
}

{ #category : #'element handlers' }
AlbEditorElementEventHandler >> elementExtentChangedEvent: anEvent [

	| target |
	target := anEvent currentTarget.
	target dispatchPrimarySelectionInvalidateEvent
]

{ #category : #'element handlers' }
AlbEditorElementEventHandler >> elementScrolledEvent: anEvent [

	| target |
	target := anEvent currentTarget.
	target dispatchPrimarySelectionInvalidateEvent
]

{ #category : #'api - accessing' }
AlbEditorElementEventHandler >> eventsToHandle [

	^ { AlbInfiniteModeChangedEvent. AlbPrimarySelectionElementClassChangedEvent. BlElementExtentChangedEvent. BlElementScrolledEvent }
]

{ #category : #'event handling' }
AlbEditorElementEventHandler >> infiniteModeChangedEvent: anEvent [

	| target |
	target := anEvent currentTarget.
	target setupModeEventHandlers.
	target dispatchPrimarySelectionInvalidateEvent
]

{ #category : #'event handling' }
AlbEditorElementEventHandler >> primarySelectionElementClassChangedEvent: anEvent [

	| target |
	target := anEvent currentTarget.
	target setupPrimarySelectionElement.
	target dispatchPrimarySelectionInvalidateEvent
]
