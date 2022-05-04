Class {
	#name : #AlbLookChanges,
	#superclass : #Object,
	#instVars : [
		'initialized',
		'changes'
	],
	#category : #'Album-Brick-Core-Changes - not used'
}

{ #category : #adding }
AlbLookChanges >> add: aChange [
	aChange source: thisContext sender method.
	changes add: aChange
]

{ #category : #accessing }
AlbLookChanges >> changes [
	^ changes
]

{ #category : #initialization }
AlbLookChanges >> downOn: aLook [
	self assert: [ initialized ].
	changes reversed do: [ :e | e downOn: aLook ].
	initialized := false
]

{ #category : #initialization }
AlbLookChanges >> initialize [
	super initialize.
	initialized := false.
	changes := OrderedCollection new
]

{ #category : #initialization }
AlbLookChanges >> upOn: aLook [
	self assert: [ initialized not ].
	changes do: [ :e | e upOn: aLook ].
	initialized := true
]
