Class {
	#name : 'AlbTextEditorAlphaNumericInputFilter',
	#superclass : 'AlbTextEditorInputFilterDecorator',
	#category : 'Album-Model-Input-filters',
	#package : 'Album',
	#tag : 'Model-Input-filters'
}

{ #category : 'accessing' }
AlbTextEditorAlphaNumericInputFilter >> filter: aString [
	<return: #String>
	
	^ (super filter: aString) select: #isAlphaNumeric
]
