Class {
	#name : #AlbTextAreaDresser,
	#superclass : #AlbEditorDresser,
	#category : #'Album-Look'
}

{ #category : #'focus handlers' }
AlbTextAreaDresser >> blurEvent: anEvent [
	anEvent target widgetContent
		border: (BlBorder paint: self theme editor borderColor width: 1)
]

{ #category : #'focus handlers' }
AlbTextAreaDresser >> focusEvent: anEvent [
	anEvent target widgetContent
		border: (BlBorder paint: self theme editor focusedBorderColor width: 1)
]

{ #category : #initialization }
AlbTextAreaDresser >> initializeListeners [
	super initializeListeners.
	
	self when: BlBlurEvent do: [ :anEvent | self blurEvent: anEvent ].
	self when: BlFocusEvent do: [ :anEvent | self focusEvent: anEvent ]
]

{ #category : #initialization }
AlbTextAreaDresser >> initializeListenersFrom: anElement [
	super initializeListenersFrom: anElement.
	
	self when: BlBlurEvent do: [ :anEvent | self blurEvent: anEvent ].
	self when: BlFocusEvent do: [ :anEvent | self focusEvent: anEvent ]
]

{ #category : #'api - hooks' }
AlbTextAreaDresser >> onAttachedTo: anElement [

	super onAttachedTo: anElement.
	anElement constraintsDo: [ :c | 
		c vertical resizer: BlLayoutResizer fitContent.
		c horizontal resizer: BlLayoutResizer matchParent ].
	anElement border: (BlBorder paint: Color blue width: 2).
	anElement widgetContent background: Color veryLightGray.
	anElement padding: (BlInsets
			 top: 10
			 left: 5
			 bottom: 10
			 right: 5)
]
