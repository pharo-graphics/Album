Class {
	#name : #AlbTextEditorDigitInputFilter,
	#superclass : #AlbTextEditorInputFilterDecorator,
	#category : #'Album-Model-Input-filters'
}

{ #category : #accessing }
AlbTextEditorDigitInputFilter >> filter: aString [
	<return: #String>
	
	^ (super filter: aString) select: #isDigit
]
