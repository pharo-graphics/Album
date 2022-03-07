Class {
	#name : #AlbTextEditorClassNameInputFilter,
	#superclass : #AlbTextEditorInputFilter,
	#category : #'Album-Editor-Model'
}

{ #category : #accessing }
AlbTextEditorClassNameInputFilter >> filter: aString [
	<return: #String>
	
	^ aString select: [ :eachCharacter | 
		eachCharacter isAlphaNumeric or: [ 
 		eachCharacter = $_ ] ]
]
