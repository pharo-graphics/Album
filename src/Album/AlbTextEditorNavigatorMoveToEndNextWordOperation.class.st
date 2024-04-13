"
I move a cursor to the end of the current word when in the middle of a word, or to the end of the next word, when at the end of the current word
"
Class {
	#name : #AlbTextEditorNavigatorMoveToEndNextWordOperation,
	#superclass : #AlbTextEditorNavigatorOperation,
	#category : #'Album-Model-Operators'
}

{ #category : #matching }
AlbTextEditorNavigatorMoveToEndNextWordOperation >> performOn: aNavigator [
	
	aNavigator
		privateRegisterForMove: self cursor
		to: (aNavigator findWordEndAfter: self cursor position) 
]
