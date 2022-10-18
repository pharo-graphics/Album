Class {
	#name : #AlbTextEditorDigitInputFilter,
	#superclass : #AlbTextEditorInputFilter,
	#category : #'Album-Model-Input-filters'
}

{ #category : #accessing }
AlbTextEditorDigitInputFilter >> filter: aString [
	<return: #String>
	
	^ aString select: #isDigit
]
