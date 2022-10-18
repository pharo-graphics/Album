Class {
	#name : #AlbTextEditorAlphaNumericInputFilter,
	#superclass : #AlbTextEditorInputFilter,
	#category : #'Album-Model-Input-filters'
}

{ #category : #accessing }
AlbTextEditorAlphaNumericInputFilter >> filter: aString [
	<return: #String>
	
	^ aString select: #isAlphaNumeric
]
