Class {
	#name : #AlbTextEditorClassNameInputFilter,
	#superclass : #AlbTextEditorInputFilterDecorator,
	#category : #'Album-Model-Input-filters'
}

{ #category : #accessing }
AlbTextEditorClassNameInputFilter >> filter: aString [
	<return: #String>
	
	^ (super filter: aString) select: [ :eachCharacter | 
		eachCharacter isAlphaNumeric or: [ 
 		eachCharacter = $_ ] ]
]
