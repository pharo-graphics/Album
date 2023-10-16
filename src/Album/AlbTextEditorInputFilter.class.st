Class {
	#name : 'AlbTextEditorInputFilter',
	#superclass : 'Object',
	#category : 'Album-Model-Input-filters',
	#package : 'Album',
	#tag : 'Model-Input-filters'
}

{ #category : 'accessing' }
AlbTextEditorInputFilter >> filter: aString [
	<return: #String>
	
	^ self subclassResponsibility
]
