Class {
	#name : #AlbTextEditorInputFilter,
	#superclass : #Object,
	#category : #'Album-Editor-Model'
}

{ #category : #accessing }
AlbTextEditorInputFilter >> filter: aString [
	<return: #String>
	
	^ self subclassResponsibility
]
