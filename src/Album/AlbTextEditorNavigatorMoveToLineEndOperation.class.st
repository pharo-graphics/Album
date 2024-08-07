Class {
	#name : #AlbTextEditorNavigatorMoveToLineEndOperation,
	#superclass : #AlbTextEditorNavigatorOperation,
	#category : #'Album-Model-Operators'
}

{ #category : #matching }
AlbTextEditorNavigatorMoveToLineEndOperation >> performOn: aNavigator [
	| aText aTextIterator foundLineBreak |
	
	aText := aNavigator text.
	aTextIterator := aText iterator: self cursor position + 1 to: aText size.

	"if we have a line break after cursor - do nothing"
	(aTextIterator hasNext and: [ aTextIterator peek isLineBreak ])
		ifTrue: [ ^ self ].

	foundLineBreak := false.
	[ aTextIterator hasNext and: [ (foundLineBreak := aTextIterator next isLineBreak) not ] ] whileTrue.

	aNavigator
		privateRegisterForMove: self cursor
		by: (aTextIterator position - self cursor position - foundLineBreak asBit)
]
