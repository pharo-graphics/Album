Class {
	#name : #AlbTextEditorClassNameInputFilter,
	#superclass : #AlbTextEditorInputFilter,
	#category : #'Album-Model-Input-filters'
}

{ #category : #accessing }
AlbTextEditorClassNameInputFilter >> filter: aString [
	<return: #String>
	
	^ aString select: [ :eachCharacter | 
		eachCharacter isAlphaNumeric or: [ 
 		eachCharacter = $_ ] ]
]
