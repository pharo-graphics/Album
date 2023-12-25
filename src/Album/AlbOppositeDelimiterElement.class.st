Class {
	#name : #AlbOppositeDelimiterElement,
	#superclass : #AlbTextPortionElement,
	#instVars : [
		'anim'
	],
	#category : 'Album-UI-Text-Portion'
}

{ #category : #initialization }
AlbOppositeDelimiterElement >> borderColor [

	^ Color gray
]

{ #category : #cleanup }
AlbOppositeDelimiterElement >> cleanUp [

	anim ifNotNil: [
		self dequeueTask: anim.
		anim := nil ]
]

{ #category : #initialization }
AlbOppositeDelimiterElement >> defaultBackground [ 

	^ Color yellow 
]

{ #category : #initialization }
AlbOppositeDelimiterElement >> initialize [

	super initialize.
	self opacity: 0.
	anim := ((BlOpacityAnimation new opacity: 1.6) duration: 300 milliSeconds).
	self addAnimation: anim
]

{ #category : #removing }
AlbOppositeDelimiterElement >> removeFromParent [ 

	self cleanUp.
	super removeFromParent 
]
