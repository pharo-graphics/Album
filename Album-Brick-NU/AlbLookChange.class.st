Class {
	#name : #AlbLookChange,
	#superclass : #Object,
	#instVars : [
		'initialized',
		'up',
		'down',
		'source'
	],
	#category : #'Album-Brick-NU-Changes'
}

{ #category : #accessing }
AlbLookChange >> down [
	^ down
]

{ #category : #accessing }
AlbLookChange >> down: aUnaryBlockClosure [
	down := aUnaryBlockClosure
]

{ #category : #initialization }
AlbLookChange >> downOn: aLook [
	self assert: [ initialized ].
	down value: aLook.
	initialized := false
]

{ #category : #initialization }
AlbLookChange >> initialize [
	super initialize.
	initialized := false.
	up := [ :e |  ].
	down := [ :e |  ]
]

{ #category : #accessing }
AlbLookChange >> initialized [
	^ initialized
]

{ #category : #accessing }
AlbLookChange >> initialized: aBoolean [
	initialized := aBoolean
]

{ #category : #accessing }
AlbLookChange >> source [
	^ source
]

{ #category : #accessing }
AlbLookChange >> source: anObject [
	source := anObject
]

{ #category : #accessing }
AlbLookChange >> up [
	^ up
]

{ #category : #accessing }
AlbLookChange >> up: aUnaryBlockClosure [
	up := aUnaryBlockClosure
]

{ #category : #initialization }
AlbLookChange >> upOn: aLook [
	self assert: [ initialized not ].
	up value: aLook.
	initialized := true
]
