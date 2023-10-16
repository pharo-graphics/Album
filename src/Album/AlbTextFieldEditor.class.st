Class {
	#name : 'AlbTextFieldEditor',
	#superclass : 'AlbTextEditor',
	#category : 'Album-Model',
	#package : 'Album',
	#tag : 'Model'
}

{ #category : 'initialization' }
AlbTextFieldEditor >> defaultSegmentCollector [

	^ AlbTextFieldEditorSegmentCollector new 
]
