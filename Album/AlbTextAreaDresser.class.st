Class {
	#name : #AlbTextAreaDresser,
	#superclass : #AlbElementCompanion,
	#category : #'Album-Look'
}

{ #category : #'api - hooks' }
AlbTextAreaDresser >> onInstalledIn: anElement [

	super onInstalledIn: anElement.
	
	anElement when: BlBlurEvent do: [ :anEvent | anElement widgetContent
		border: (BlBorder paint: anElement theme editor borderColor width: 1) ].
	anElement when: BlFocusEvent do: [ :anEvent | anElement widgetContent
		border: (BlBorder paint: anElement theme editor focusedBorderColor width: 1) ].
	
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
