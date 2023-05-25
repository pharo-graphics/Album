Class {
	#name : #AlbSubtextDecorationBuilder,
	#superclass : #Object,
	#instVars : [
		'subtext',
		'fullText',
		'parentElement',
		'decorations'
	],
	#category : #'Album-UI'
}

{ #category : #building }
AlbSubtextDecorationBuilder >> createDecorations [

	| collector founds |
	subtext ifNil: [ ^ self ].
	subtext ifEmpty: [ ^ self ].
	collector := BlIntervalCollector new text: fullText asString.
	founds := collector searchAll: subtext asString.
	founds do: [ :interval | self decorationInterval: interval + fullText textOffset ]
]

{ #category : #private }
AlbSubtextDecorationBuilder >> decorationInterval: anInterval [

	anInterval = (parentElement selection from + 1 to: parentElement selection to) ifTrue: [ ^ self ].
	decorations add: (AlbSubtextDecorationElement new
			 editorElement: parentElement;
			 interval: anInterval;
			 yourself)
]

{ #category : #accessing }
AlbSubtextDecorationBuilder >> decorations [

	^ decorations

]

{ #category : #accessing }
AlbSubtextDecorationBuilder >> fullText: aSubtext [

	fullText := aSubtext
]

{ #category : #initialization }
AlbSubtextDecorationBuilder >> initialize [ 

	super initialize.
	decorations := OrderedCollection new
]

{ #category : #accessing }
AlbSubtextDecorationBuilder >> parentElement: anObject [

	parentElement := anObject
]

{ #category : #accessing }
AlbSubtextDecorationBuilder >> subtext: aSubtext [

	subtext := aSubtext
]
