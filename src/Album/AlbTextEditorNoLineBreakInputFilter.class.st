Class {
	#name : #AlbTextEditorNoLineBreakInputFilter,
	#superclass : #AlbTextEditorInputFilter,
	#category : #'Album-Model-Input-filters'
}

{ #category : #accessing }
AlbTextEditorNoLineBreakInputFilter >> filter: aString [

	<return: #String>
	^ aString reject: #isLineBreak
]
