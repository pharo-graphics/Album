"
AlbTextEditorSurroundDefinition defines a character that the text editor will automatically close when the character is inserted, e.g. an opening bracket will have its closing bracket also inserted.

Some characters, e.g. quotes, should only be inserted if surrounded by spaces.  The optional condition can be specified to allow this.

!!Internal Representation and Key Implementation Points.

!!!Instance Variables
	closeCharacter:		<Character>
	condition:			<BlockClosure>
	openCharacter:		<Character>


!!!Implementation Points
"
Class {
	#name : #AlbTextEditorSurroundDefinition,
	#superclass : #Object,
	#instVars : [
		'openCharacter',
		'closeCharacter',
		'condition'
	],
	#category : #'Album-Model-Operators'
}

{ #category : #accessing }
AlbTextEditorSurroundDefinition >> closeCharacter [
	^ closeCharacter
]

{ #category : #accessing }
AlbTextEditorSurroundDefinition >> closeCharacter: anObject [
	closeCharacter := anObject
]

{ #category : #accessing }
AlbTextEditorSurroundDefinition >> condition [
	^ condition
]

{ #category : #accessing }
AlbTextEditorSurroundDefinition >> condition: anObject [
	condition := anObject
]

{ #category : #accessing }
AlbTextEditorSurroundDefinition >> openCharacter [
	^ openCharacter
]

{ #category : #accessing }
AlbTextEditorSurroundDefinition >> openCharacter: anObject [
	openCharacter := anObject
]
