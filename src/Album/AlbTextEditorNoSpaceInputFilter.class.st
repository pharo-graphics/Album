Class {
	#name : #AlbTextEditorNoSpaceInputFilter,
	#superclass : #AlbTextEditorInputFilter,
	#category : #'Album-Model-Input-filters'
}

{ #category : #accessing }
AlbTextEditorNoSpaceInputFilter >> filter: aString [
	<return: #String>
	
	^ aString reject: #isSeparator
]
