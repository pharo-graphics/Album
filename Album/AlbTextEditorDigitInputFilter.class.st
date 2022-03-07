Class {
	#name : #AlbTextEditorDigitInputFilter,
	#superclass : #AlbTextEditorInputFilter,
	#category : #'Album-Editor-Model'
}

{ #category : #accessing }
AlbTextEditorDigitInputFilter >> filter: aString [
	<return: #String>
	
	^ aString select: #isDigit
]
