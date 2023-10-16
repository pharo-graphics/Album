Class {
	#name : 'AlbTextReplacingAttributeStrategy',
	#superclass : 'Object',
	#category : 'Album-Attributes - Support',
	#package : 'Album',
	#tag : 'Attributes - Support'
}

{ #category : 'replacing' }
AlbTextReplacingAttributeStrategy >> swapString: aString [
	<return: #String>
	
	^ self subclassResponsibility
]
