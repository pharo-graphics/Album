Class {
	#name : 'AlbTextEditorNoInputFilter',
	#superclass : 'AlbTextEditorInputFilter',
	#category : 'Album-Model-Input-filters',
	#package : 'Album',
	#tag : 'Model-Input-filters'
}

{ #category : 'accessing' }
AlbTextEditorNoInputFilter >> filter: aString [
	<return: #String>
	
	^ aString
]
