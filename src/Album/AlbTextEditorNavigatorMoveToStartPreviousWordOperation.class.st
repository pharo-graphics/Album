"
I move a cursor to the beginning of the current word when in the middle of a word, or to the beginning of the previous word, when at the beginning of the current word
"
Class {
	#name : 'AlbTextEditorNavigatorMoveToStartPreviousWordOperation',
	#superclass : 'AlbTextEditorNavigatorOperation',
	#category : 'Album-Model-Operators',
	#package : 'Album',
	#tag : 'Model-Operators'
}

{ #category : 'matching' }
AlbTextEditorNavigatorMoveToStartPreviousWordOperation >> performOn: aNavigator [
	"Moves cursor to the left until the start of the previous word"
	
	aNavigator
		privateRegisterForMove: self cursor
		to: (aNavigator findWordStartBefore: self cursor position) 
]
