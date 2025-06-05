Class {
	#name : #AlbOppositeDelimiterElement,
	#superclass : #AlbTextPortionElement,
	#instVars : [
		'anim'
	],
	#category : #'Album-UI-Text-Portion'
}

{ #category : #accessing }
AlbOppositeDelimiterElement >> borderColor [

	^ Color yellow twiceDarker
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
AlbOppositeDelimiterElement >> defaultGeometry [

	^ BlRoundedRectangleGeometry cornerRadius: 3
]

{ #category : #initialization }
AlbOppositeDelimiterElement >> initialize [

	super initialize.
	self geometry: self defaultGeometry.
	self opacity: 0.
	anim := BlSequentialAnimation
		        with:
		        ((BlOpacityAnimation new opacity: 3.6) duration:
			         300 milliSeconds)
		        with:
		        ((BlOpacityAnimation new opacity: 0.3) duration:
			         300 milliSeconds).
	anim onFinishedDo: [self border: Color orange].
	self addAnimation: anim
]

{ #category : #'children add/remove' }
AlbOppositeDelimiterElement >> removeFromParent [ 

	self cleanUp.
	super removeFromParent 
]
