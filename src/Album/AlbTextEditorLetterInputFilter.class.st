Class {
	#name : #AlbTextEditorLetterInputFilter,
	#superclass : #AlbTextEditorInputFilter,
	#category : #'Album-Model'
}

{ #category : #accessing }
AlbTextEditorLetterInputFilter >> filter: aString [
	<return: #String>
	
	^ aString select: #isLetter
]
