Class {
	#name : #AlbTextFieldEditor,
	#superclass : #AlbTextEditor,
	#category : 'Album-Model'
}

{ #category : #initialization }
AlbTextFieldEditor >> defaultSegmentCollector [

	^ AlbTextFieldEditorSegmentCollector new 
]
