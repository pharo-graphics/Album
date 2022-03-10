Class {
	#name : #AlbTextReplacingAttributeStrategy,
	#superclass : #Object,
	#category : #'Album-Editor-Attributes - Support'
}

{ #category : #replacing }
AlbTextReplacingAttributeStrategy >> swapString: aString [
	<return: #String>
	
	^ self subclassResponsibility
]
