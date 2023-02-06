Class {
	#name : #AlbOppositeDelimiter,
	#superclass : #AlbTextDecorationElement,
	#instVars : [
		'anim'
	],
	#category : #'Album-UI'
}

{ #category : #initialization }
AlbOppositeDelimiter >> borderColor [

	^ Color gray
]

{ #category : #cleanup }
AlbOppositeDelimiter >> cleanUp [

	anim ifNotNil: [
		self dequeueTask: anim.
		anim := nil ]
]

{ #category : #initialization }
AlbOppositeDelimiter >> defaultBackground [ 

	^ Color yellow 
]

{ #category : #initialization }
AlbOppositeDelimiter >> initialize [

	super initialize.
	self opacity: 0.
	anim := ((BlOpacityAnimation new opacity: 1.6) duration: 800 milliSeconds).
	self addAnimation: anim
]

{ #category : #removing }
AlbOppositeDelimiter >> removeFromParent [ 

	self cleanUp.
	super removeFromParent 
]
