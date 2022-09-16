Class {
	#name : #AlbTextAdornmentAttributeCache,
	#superclass : #Object,
	#category : #'Album-Brick-NU-Attributes - Support'
}

{ #category : #'api - cache' }
AlbTextAdornmentAttributeCache >> ifAbsentPut: aBlock [
	"Return available cached elements previously created by an adornment attribute"
	<return: #SequenceableCollection of: #BlElement>

	^ self subclassResponsibility
]
