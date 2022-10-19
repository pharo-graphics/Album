Class {
	#name : #AlbEditorPharoCodeModel,
	#superclass : #AlbEditorWithSaveTransactionModel,
	#category : #'Album-Model'
}

{ #category : #accessing }
AlbEditorPharoCodeModel >> classOrMetaClass: aClass [

	self stylerHolder classOrMetaClass: aClass
]

{ #category : #initialization }
AlbEditorPharoCodeModel >> defaultStyler [

	^ BlRBTextStyler new fontName: self fontName 
]

{ #category : #accessing }
AlbEditorPharoCodeModel >> isForWorkspace: aBoolean [

	self stylerHolder isForWorkspace: aBoolean
]

{ #category : #accessing }
AlbEditorPharoCodeModel >> workspace: aWorkspace [

	self stylerHolder workspace: aWorkspace
]
