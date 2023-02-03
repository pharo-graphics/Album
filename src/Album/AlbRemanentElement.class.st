Class {
	#name : #AlbRemanentElement,
	#superclass : #AlbTextPortionElement,
	#instVars : [
		'text',
		'interval'
	],
	#category : #'Album-UI'
}

{ #category : #accessing }
AlbRemanentElement >> initialize [ 

	super initialize.
	self background: self defaultBackground.
	self border:	self defaultBorder
]

{ #category : #accessing }
AlbRemanentElement >> interval [

	^ interval
]

{ #category : #accessing }
AlbRemanentElement >> interval: anInterval [

	interval := anInterval
]

{ #category : #accessing }
AlbRemanentElement >> text [

	^ text
]

{ #category : #accessing }
AlbRemanentElement >> text: aText [

	text := aText
]
