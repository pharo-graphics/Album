Class {
	#name : #AlbTextAreaDresser,
	#superclass : #OBlElementCompanion,
	#category : #'Album-Look'
}

{ #category : #'api - hooks' }
AlbTextAreaDresser >> onInstalledIn: anElement [

	super onInstalledIn: anElement.

	anElement
		when: BlBlurEvent
		do: [ :anEvent | 
			anElement widgetContent border: (BlBorder
					 paint: anElement theme editor borderColor
					 width: 1) ].
	anElement
		when: BlFocusEvent
		do: [ :anEvent | 
			anElement widgetContent border: (BlBorder
					 paint: anElement theme editor focusedBorderColor
					 width: 1) ].

	anElement border: (BlBorder
			 paint: anElement theme editor borderColor
			 width: 1).
	anElement widgetContent background: Color white
]
