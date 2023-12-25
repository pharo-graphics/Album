Class {
	#name : #AlbTextEditorNavigatorMoveToLineStartOperation,
	#superclass : #AlbTextEditorNavigatorOperation,
	#category : 'Album-Model-Operators'
}

{ #category : #matching }
AlbTextEditorNavigatorMoveToLineStartOperation >> performOn: aNavigator [
	| aDelta |	

	aDelta := (aNavigator findTextIndexAtLineStart: self cursor) - self cursor position.
	aDelta isZero
		ifTrue: [ ^ self ].

	aNavigator
		privateRegisterForMove: self cursor
		by: aDelta
]
