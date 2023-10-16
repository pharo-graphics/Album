Class {
	#name : 'AlbTextEditorLetterInputFilter',
	#superclass : 'AlbTextEditorInputFilterDecorator',
	#category : 'Album-Model-Input-filters',
	#package : 'Album',
	#tag : 'Model-Input-filters'
}

{ #category : 'accessing' }
AlbTextEditorLetterInputFilter >> filter: aString [
	<return: #String>
	
	^ (super filter: aString) select: #isLetter
]
