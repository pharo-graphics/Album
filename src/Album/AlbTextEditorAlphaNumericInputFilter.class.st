Class {
	#name : #AlbTextEditorAlphaNumericInputFilter,
	#superclass : #AlbTextEditorInputFilter,
	#category : #'Album-Model'
}

{ #category : #accessing }
AlbTextEditorAlphaNumericInputFilter >> filter: aString [
	<return: #String>
	
	^ aString select: #isAlphaNumeric
]
