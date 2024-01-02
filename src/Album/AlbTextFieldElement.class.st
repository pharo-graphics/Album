Class {
	#name : #AlbTextFieldElement,
	#superclass : #AlbEditorElement,
	#category : #'Album-UI'
}

{ #category : #initialization }
AlbTextFieldElement >> defaultInfiniteElement [  

	^ AlbInfiniteTextFieldElement new
]

{ #category : #initialization }
AlbTextFieldElement >> defaultRemanentSubtextEventHandlers [

	^ {  }
]
