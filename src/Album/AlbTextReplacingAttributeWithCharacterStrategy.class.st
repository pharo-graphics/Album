Class {
	#name : 'AlbTextReplacingAttributeWithCharacterStrategy',
	#superclass : 'AlbTextReplacingAttributeStrategy',
	#instVars : [
		'character'
	],
	#category : 'Album-Attributes - Support',
	#package : 'Album',
	#tag : 'Attributes - Support'
}

{ #category : 'accessing' }
AlbTextReplacingAttributeWithCharacterStrategy >> character [
	^ character
]

{ #category : 'accessing' }
AlbTextReplacingAttributeWithCharacterStrategy >> character: anObject [
	character := anObject
]

{ #category : 'initialization' }
AlbTextReplacingAttributeWithCharacterStrategy >> initialize [
	super initialize.
	
	character := $*
]

{ #category : 'replacing' }
AlbTextReplacingAttributeWithCharacterStrategy >> swapString: aString [
	<return: #String>
	
	^ String new: aString size withAll: character
]
