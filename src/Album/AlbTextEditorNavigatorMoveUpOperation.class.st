Class {
	#name : #AlbTextEditorNavigatorMoveUpOperation,
	#superclass : #AlbTextEditorNavigatorOperation,
	#category : #'Album-Model-Operators'
}

{ #category : #matching }
AlbTextEditorNavigatorMoveUpOperation >> performOn: aNavigator [
	| aGlobalTextIndex |
	
	aGlobalTextIndex := aNavigator
		findTextIndexAboveCursor: self cursor
		ifAbsent: [
			"a cursor position is not found, maybe we are at the first line?"
			(aNavigator isCursorOnTheFirstLine: self cursor)
				ifFalse: [ ^ self ]
				ifTrue: [
					| anEvent |
					anEvent := AlbTextEditorCursorReachedBoundaryEvent new
						beTop;
						cursor: self cursor.
					aNavigator editor dispatchEvent: anEvent.
					anEvent isConsumed
						"it was handled by somebody else, do nothing"
						ifTrue: [ ^ self ]
						ifFalse: [ 0 ] ] ].

	aNavigator
		privateRegisterForMove: self cursor
		by: (aGlobalTextIndex - self cursor position)
]
