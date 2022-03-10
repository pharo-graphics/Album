Class {
	#name : #AlbTextEditorInputFilter,
	#superclass : #Object,
	#category : #'Album-Model'
}

{ #category : #accessing }
AlbTextEditorInputFilter >> filter: aString [
	<return: #String>
	
	^ self subclassResponsibility
]
