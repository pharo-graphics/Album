Class {
	#name : #AlbTextAdornmentAttributeNoCache,
	#superclass : #AlbTextAdornmentAttributeCache,
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'Album-Attributes - Support'
}

{ #category : #accessing }
AlbTextAdornmentAttributeNoCache class >> cleanUp [
	uniqueInstance := nil
]

{ #category : #accessing }
AlbTextAdornmentAttributeNoCache class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
]

{ #category : #'api - cache' }
AlbTextAdornmentAttributeNoCache >> ifAbsentPut: aBlock [
	"When cache is not enabled delegate back to the attribute"
	<return: #SequenceableCollection of: #BlElement>

	^ aBlock value
]
