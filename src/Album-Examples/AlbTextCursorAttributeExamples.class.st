Class {
	#name : #AlbTextCursorAttributeExamples,
	#superclass : #AlbTextEditorAdornmentsExamples,
	#category : #'Album-Examples-! Documentation'
}

{ #category : #public }
AlbTextCursorAttributeExamples >> changingForeground [
	<gtExample>
	| text |
	text := 'Hello World
- click here
- second item' asRopedText fontSize: 20.

	(text from: 13 to: 24)
		onCursorEnter: [ :aTextEditor :anEvent :aFromIndex :aToIndex |
			(aTextEditor text from: aFromIndex to: aToIndex) foreground: Color red ]
		leave: [ :aTextEditor :anEvent :aFromIndex :aToIndex |
			(aTextEditor text from: aFromIndex to: aToIndex) foreground: Color blue ].

	^ text
]
