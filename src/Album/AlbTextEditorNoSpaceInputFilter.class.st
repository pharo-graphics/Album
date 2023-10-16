Class {
	#name : 'AlbTextEditorNoSpaceInputFilter',
	#superclass : 'AlbTextEditorInputFilterDecorator',
	#category : 'Album-Model-Input-filters',
	#package : 'Album',
	#tag : 'Model-Input-filters'
}

{ #category : 'accessing' }
AlbTextEditorNoSpaceInputFilter >> filter: aString [
	<return: #String>
	
	^ (super filter: aString) reject: #isSeparator
]
