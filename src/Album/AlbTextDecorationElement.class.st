Class {
	#name : #AlbTextDecorationElement,
	#superclass : #BlElement,
	#instVars : [
		'interval',
		'subtext'
	],
	#category : #'Album-UI'
}

{ #category : #accessing }
AlbTextDecorationElement >> borderColor [

	^ Color black
]

{ #category : #accessing }
AlbTextDecorationElement >> borderWidth [

	^ 1
]

{ #category : #initialization }
AlbTextDecorationElement >> defaultBackground [ 

	^ Color transparent 
]

{ #category : #accessing }
AlbTextDecorationElement >> defaultBorder [

	^ BlBorder paint: self borderColor width: self borderWidth
]

{ #category : #initialization }
AlbTextDecorationElement >> initialize [ 

	super initialize.
	self background: self defaultBackground.
	self border:	self defaultBorder.
	self constraintsDo: [ :c | c ignoreByLayout  ].
	self outskirts: (BlOutskirts centered).


]

{ #category : #accessing }
AlbTextDecorationElement >> interval [

	^ interval
]

{ #category : #accessing }
AlbTextDecorationElement >> interval: anInterval [

	interval := anInterval
]

{ #category : #accessing }
AlbTextDecorationElement >> subtext [

	^ subtext
]

{ #category : #accessing }
AlbTextDecorationElement >> subtext: asubText [

	subtext := asubText
]
