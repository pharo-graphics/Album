Trait {
	#name : #TAlbTextEditorTextualPiece,
	#instVars : [
		'text',
		'textStart',
		'textEnd',
		'delimiterLength'
	],
	#category : #'Album-Model-Segment-Text'
}

{ #category : #'text - copying' }
TAlbTextEditorTextualPiece >> copyWithText: aBlText [
	^ self copy
		initializeWith: aBlText
		from: self textStart
		to: self textEnd
		delimiter: delimiterLength
]

{ #category : #'text - accessing' }
TAlbTextEditorTextualPiece >> delimiterLength [
	^ delimiterLength
]

{ #category : #initialization }
TAlbTextEditorTextualPiece >> initializeWith: aBlText from: aTextStart to: aTextEnd [
	self
		initializeWith: aBlText
		from: aTextStart
		to: aTextEnd
		delimiter: 0
]

{ #category : #initialization }
TAlbTextEditorTextualPiece >> initializeWith: aBlText from: aTextStart to: aTextEnd delimiter: aDelimiterLength [
	text := aBlText.
	
	textStart := aTextStart.
	textEnd := aTextEnd.
	delimiterLength := aDelimiterLength
]

{ #category : #'text - testing' }
TAlbTextEditorTextualPiece >> isEmpty [
	"Return true if my text is empty, false otherwise"
	<return: #Boolean>

	^ self textLength isZero
]

{ #category : #'text - modifications' }
TAlbTextEditorTextualPiece >> scopeText: aStartIndex end: anEndIndex [
	self start: aStartIndex end: anEndIndex
]

{ #category : #'private - text' }
TAlbTextEditorTextualPiece >> start: aStartIndex end: anEndIndex [
	"aStartIndex and anEndIndex are given in cursor coordinates"
	| aDelta |
	
	aDelta := (text textOffset - textStart) max: 0.
	
	self
		assert: [ aStartIndex <= anEndIndex ]
		description: [ 'Start must be less than end' ].

	text
		start: (aStartIndex + 1) + aDelta
		end: anEndIndex + aDelta.

	"text start and end are given in cursor coordinates of the text editor which may be opened on a subtext"
	textStart := aStartIndex.
	textEnd := anEndIndex
]

{ #category : #'text - accessing' }
TAlbTextEditorTextualPiece >> text [
	"Return a sub-text that I represent"
	<return: #BlSubText>

	^ text
]

{ #category : #'text - accessing' }
TAlbTextEditorTextualPiece >> textEnd [
	"Return an index of the last character of a subtext that I represent"
	<return: #Number>
	
	^ textEnd
]

{ #category : #'text - accessing' }
TAlbTextEditorTextualPiece >> textEndDelimited [
	"Return an index of the last character of a subtext that I represent including the possible delimiter"
	<return: #Number>
	
	^ textEnd + delimiterLength
]

{ #category : #'text - accessing' }
TAlbTextEditorTextualPiece >> textInterval [
	"Return both #textStart and #textEnd in a form of Interval"
	<return: #Interval>
	
	^ self textStart to: self textEnd
]

{ #category : #'text - accessing' }
TAlbTextEditorTextualPiece >> textLength [
	"Return an index of the last character of a subtext that I represent"
	<return: #Number>
	
	^ self textEnd - self textStart
]

{ #category : #'text - accessing' }
TAlbTextEditorTextualPiece >> textStart [
	"Return an index of the first character of a subtext that I represent"
	<return: #Number>
	
	^ textStart
]
