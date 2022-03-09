Class {
	#name : #AlbTextAreaAptitude,
	#superclass : #AlbEditorAptitude,
	#category : #'Album-Editor-Look'
}

{ #category : #'focus handlers' }
AlbTextAreaAptitude >> blurEvent: anEvent [
	self widgetContent
		border: (BlBorder paint: self theme editor borderColor width: 1)
]

{ #category : #'focus handlers' }
AlbTextAreaAptitude >> focusEvent: anEvent [
	self widgetContent
		border: (BlBorder paint: self theme editor focusedBorderColor width: 1)
]

{ #category : #initialization }
AlbTextAreaAptitude >> initialize [
	super initialize.

]

{ #category : #initialization }
AlbTextAreaAptitude >> initializeListeners [
	super initializeListeners.
	
	self when: BlBlurEvent do: [ :anEvent | self blurEvent: anEvent ].
	self when: BlFocusEvent do: [ :anEvent | self focusEvent: anEvent ]
]

{ #category : #'api - hooks' }
AlbTextAreaAptitude >> onAttachedTo: anElement [

	super onAttachedTo: anElement.
	anElement constraintsDo: [ :c | 
		c vertical resizer: BlLayoutResizer fitContent.
		c horizontal resizer: BlLayoutResizer matchParent ].
	anElement border: (BlBorder paint: Color blue width: 2).
	self widgetContent background: Color veryLightGray.
	anElement padding: (BlInsets
			 top: 10
			 left: 5
			 bottom: 10
			 right: 5)
]
