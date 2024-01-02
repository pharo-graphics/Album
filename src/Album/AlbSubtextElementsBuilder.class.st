Class {
	#name : #AlbSubtextElementsBuilder,
	#superclass : #Object,
	#instVars : [
		'subtext',
		'fullText',
		'parentElement',
		'decorations'
	],
	#category : #'Album-UI-Text-Portion'
}

{ #category : #building }
AlbSubtextElementsBuilder >> createDecorations [

	| collector founds |
	subtext ifNil: [ ^ self ].
	subtext ifEmpty: [ ^ self ].
	collector := BlIntervalCollector new text: fullText asString.
	founds := collector searchAll: subtext asString.
	founds do: [ :interval | self decorationInterval: interval + fullText textOffset ]
]

{ #category : #private }
AlbSubtextElementsBuilder >> decorationInterval: anInterval [

	anInterval = (parentElement selection from + 1 to: parentElement selection to) ifTrue: [ ^ self ].
	decorations add: ((AlbSubtextElement  editorElement: parentElement)
			 interval: anInterval;
			 yourself)
]

{ #category : #accessing }
AlbSubtextElementsBuilder >> decorations [

	^ decorations

]

{ #category : #accessing }
AlbSubtextElementsBuilder >> fullText: aSubtext [

	fullText := aSubtext
]

{ #category : #initialization }
AlbSubtextElementsBuilder >> initialize [ 

	super initialize.
	decorations := OrderedCollection new
]

{ #category : #accessing }
AlbSubtextElementsBuilder >> parentElement: anObject [

	parentElement := anObject
]

{ #category : #accessing }
AlbSubtextElementsBuilder >> subtext: aSubtext [

	subtext := aSubtext
]
