Class {
	#name : #AlbTextEditorNoSpaceInputFilter,
	#superclass : #AlbTextEditorInputFilter,
	#category : #'Album-Model'
}

{ #category : #accessing }
AlbTextEditorNoSpaceInputFilter >> filter: aString [
	<return: #String>
	
	^ aString reject: #isSeparator
]
