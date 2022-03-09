Class {
	#name : #AlbLookPropertyChange2,
	#superclass : #Object,
	#instVars : [
		'initialized',
		'old',
		'new',
		'read',
		'path',
		'value',
		'oldV',
		'newV',
		'readBlock',
		'writeBlock',
		'propertyValue',
		'source',
		'up',
		'down'
	],
	#category : #'Album-Core-Changes'
}

{ #category : #initialization }
AlbLookPropertyChange2 >> downOn: aLook [
	self assert: [ initialized ].
	down value: aLook value: old value: new.
	old := nil.
	new := nil.
	initialized := false
]

{ #category : #initialization }
AlbLookPropertyChange2 >> initialize [
	super initialize.
	initialized := false.
	read := [ :e | self readOn: e ].
	up := [ :e :f | 
	self
		writeOn: e 
		value:
			(value isBlock
				ifTrue: [ value cull: f ]
				ifFalse: [ value ]) ].
	down := [ :e :f :g | self writeOn: e value: f ]
]

{ #category : #accessing }
AlbLookPropertyChange2 >> newV: aBlock [
	newV := aBlock
]

{ #category : #accessing }
AlbLookPropertyChange2 >> oldV: aBlock [
	oldV := aBlock
]

{ #category : #accessing }
AlbLookPropertyChange2 >> path [
	^ path
]

{ #category : #accessing }
AlbLookPropertyChange2 >> path: anObject [
	path := anObject
]

{ #category : #printing }
AlbLookPropertyChange2 >> printOn: aStream [
	aStream nextPutAll: (' ' join: (path collect: #asString))
]

{ #category : #accessing }
AlbLookPropertyChange2 >> propertyValue: anObject [
	propertyValue := anObject
]

{ #category : #accessing }
AlbLookPropertyChange2 >> readBlock: aBlock [
	readBlock := aBlock
]

{ #category : #initialization }
AlbLookPropertyChange2 >> readOn: aLook [

	^ readBlock value: aLook
]

{ #category : #accessing }
AlbLookPropertyChange2 >> source: anObject [
	source := anObject
]

{ #category : #initialization }
AlbLookPropertyChange2 >> upOn: aLook [
	self assert: [ initialized not ].
	old := self readOn: aLook.
	self writeOn: aLook value: self value.
	up value: aLook value: old.
	new := self readOn: aLook.
	initialized := true
]

{ #category : #accessing }
AlbLookPropertyChange2 >> value [
	^ value
]

{ #category : #accessing }
AlbLookPropertyChange2 >> value: anObject [
	value := anObject
]

{ #category : #accessing }
AlbLookPropertyChange2 >> writeBlock: aBlock [
	writeBlock := aBlock
]

{ #category : #initialization }
AlbLookPropertyChange2 >> writeOn: aLook value: anObject [
	
	^ writeBlock value: aLook value: anObject
]
