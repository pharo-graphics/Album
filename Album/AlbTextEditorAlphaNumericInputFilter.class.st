Class {
	#name : #AlbTextEditorAlphaNumericInputFilter,
	#superclass : #AlbTextEditorInputFilter,
	#category : #'Album-Editor-Model'
}

{ #category : #accessing }
AlbTextEditorAlphaNumericInputFilter >> filter: aString [
	<return: #String>
	
	^ aString select: #isAlphaNumeric
]
