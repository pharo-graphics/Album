Class {
	#name : #AlbTextAdornmentAttributeCache,
	#superclass : #Object,
	#category : #'Album-Editor-Attributes - Support'
}

{ #category : #'api - cache' }
AlbTextAdornmentAttributeCache >> ifAbsentPut: aBlock [
	"Return available cached elements previously created by an adornment attribute"
	<return: #SequenceableCollection of: #BlElement>

	^ self subclassResponsibility
]
