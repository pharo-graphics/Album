Class {
	#name : #AlbSubtextPortionBuilder,
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
AlbSubtextPortionBuilder >> createDecorations [

	| collector founds |
	subtext ifNil: [ ^ self ].
	subtext ifEmpty: [ ^ self ].
	collector := BlIntervalCollector new text: fullText asString.
	founds := collector searchAll: subtext asString.
	founds do: [ :interval | self decorationInterval: interval + fullText textOffset ]
]

{ #category : #private }
AlbSubtextPortionBuilder >> decorationInterval: anInterval [

	anInterval = (parentElement selection from + 1 to: parentElement selection to) ifTrue: [ ^ self ].
	decorations add: ((AlbSubtextElement  editorElement: parentElement)
			 interval: anInterval;
			 yourself)
]

{ #category : #accessing }
AlbSubtextPortionBuilder >> decorations [

	^ decorations

]

{ #category : #accessing }
AlbSubtextPortionBuilder >> fullText: aSubtext [

	fullText := aSubtext
]

{ #category : #initialization }
AlbSubtextPortionBuilder >> initialize [ 

	super initialize.
	decorations := OrderedCollection new
]

{ #category : #accessing }
AlbSubtextPortionBuilder >> parentElement: anObject [

	parentElement := anObject
]

{ #category : #accessing }
AlbSubtextPortionBuilder >> subtext: aSubtext [

	subtext := aSubtext
]
