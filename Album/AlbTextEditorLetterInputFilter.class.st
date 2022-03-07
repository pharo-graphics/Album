Class {
	#name : #AlbTextEditorLetterInputFilter,
	#superclass : #AlbTextEditorInputFilter,
	#category : #'Album-Editor-Model'
}

{ #category : #accessing }
AlbTextEditorLetterInputFilter >> filter: aString [
	<return: #String>
	
	^ aString select: #isLetter
]
