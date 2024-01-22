Class {
	#name : #AlbEditorElementEventHandler,
	#superclass : #BlCustomEventHandler,
	#category : #'Album-UI'
}

{ #category : #'event handling' }
AlbEditorElementEventHandler >> blurEvent: anEvent [

	anEvent currentTarget primarySelectionElement dispatchEvent: anEvent copy
]

{ #category : #'element handlers' }
AlbEditorElementEventHandler >> elementExtentChangedEvent: anEvent [

	| target |
	target := anEvent currentTarget.
	target dispatchPrimarySelectionInvalidateEvent
]

{ #category : #'element handlers' }
AlbEditorElementEventHandler >> elementScrolledEvent: anEvent [

	| target |
	anEvent delta isZero ifTrue: [ ^ self ].
	target := anEvent currentTarget.
	target dispatchPrimarySelectionInvalidateEvent
]

{ #category : #'api - accessing' }
AlbEditorElementEventHandler >> eventsToHandle [

	^ {
		  BlMouseUpEvent.
		  AlbInfiniteModeChangedEvent.
		  AlbPrimarySelectionElementClassChangedEvent.
		  BlElementExtentChangedEvent.
		  BlElementScrolledEvent.
		  BlFocusEvent.
		  BlBlurEvent }
]

{ #category : #'event handling' }
AlbEditorElementEventHandler >> focusEvent: anEvent [

	anEvent currentTarget primarySelectionElement dispatchEvent: anEvent copy
]

{ #category : #'event handling' }
AlbEditorElementEventHandler >> infiniteModeChangedEvent: anEvent [

	| target |
	target := anEvent currentTarget.
	target setupModeEventHandlers.
	target dispatchPrimarySelectionInvalidateEvent
]

{ #category : #'element handlers' }
AlbEditorElementEventHandler >> mouseUpEvent: anEvent [

	| target |
	target := anEvent currentTarget.
	target dispatchPrimarySelectionInvalidateEvent
]

{ #category : #'event handling' }
AlbEditorElementEventHandler >> primarySelectionElementClassChangedEvent: anEvent [

	| target |
	target := anEvent currentTarget.
	target setupPrimarySelectionElement.
	target dispatchPrimarySelectionInvalidateEvent
]
