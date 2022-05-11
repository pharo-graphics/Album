Class {
	#name : #AlbTextEditorDigitInputFilter,
	#superclass : #AlbTextEditorInputFilter,
	#category : #'Album-Model'
}

{ #category : #accessing }
AlbTextEditorDigitInputFilter >> filter: aString [
	<return: #String>
	
	^ aString select: #isDigit
]
