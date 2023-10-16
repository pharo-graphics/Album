Class {
	#name : 'AlbTextEditorNoLineBreakInputFilter',
	#superclass : 'AlbTextEditorInputFilterDecorator',
	#category : 'Album-Model-Input-filters',
	#package : 'Album',
	#tag : 'Model-Input-filters'
}

{ #category : 'accessing' }
AlbTextEditorNoLineBreakInputFilter >> filter: aString [

	<return: #String>
	^ (super filter: aString) reject: #isLineBreak
]
