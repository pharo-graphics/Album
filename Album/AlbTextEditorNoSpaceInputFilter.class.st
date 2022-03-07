Class {
	#name : #AlbTextEditorNoSpaceInputFilter,
	#superclass : #AlbTextEditorInputFilter,
	#category : #'Album-Editor-Model'
}

{ #category : #accessing }
AlbTextEditorNoSpaceInputFilter >> filter: aString [
	<return: #String>
	
	^ aString reject: #isSeparator
]
