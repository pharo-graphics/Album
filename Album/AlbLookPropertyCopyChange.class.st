Class {
	#name : #AlbLookPropertyCopyChange,
	#superclass : #AlbLookPropertyChange,
	#category : #'Album-Brick-Core-Changes'
}

{ #category : #initialization }
AlbLookPropertyCopyChange >> initialize [
	super initialize.
	up := [ :e :f | 
	self
		writeOn: e
		value:
			(value isBlock
				ifTrue: [ value cull: f ]
				ifFalse: [ value ]) copy ].
	down := [ :e :f :g | self writeOn: e value: f copy ]
]

{ #category : #printing }
AlbLookPropertyCopyChange >> printOn: aStream [
	aStream nextPutAll: 'copy '.
	super printOn: aStream
]
