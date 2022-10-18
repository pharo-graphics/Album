Class {
	#name : #AlbTextEditorLetterInputFilter,
	#superclass : #AlbTextEditorInputFilter,
	#category : #'Album-Model-Input-filters'
}

{ #category : #accessing }
AlbTextEditorLetterInputFilter >> filter: aString [
	<return: #String>
	
	^ aString select: #isLetter
]
