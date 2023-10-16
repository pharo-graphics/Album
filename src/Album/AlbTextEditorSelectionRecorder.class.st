Class {
	#name : 'AlbTextEditorSelectionRecorder',
	#superclass : 'Object',
	#category : 'Album-Model-Selection',
	#package : 'Album',
	#tag : 'Model-Selection'
}

{ #category : 'selection' }
AlbTextEditorSelectionRecorder >> commit: aTextEditor [
	"Commit recorded selection intervals in a given text editor"
	
	self subclassResponsibility
]

{ #category : 'selection' }
AlbTextEditorSelectionRecorder >> deselect: aMonotoneTextSelection in: aTextEditor [
	"Remove a given selection from recorded selections"
	
	self subclassResponsibility
]

{ #category : 'selection' }
AlbTextEditorSelectionRecorder >> prepare: aTextEditor [
	"Prepare recorder for accepting selection intervals"
	
	^ self subclassResponsibility
]

{ #category : 'selection' }
AlbTextEditorSelectionRecorder >> select: aMonotoneTextSelection in: aTextEditor [
	"Add a given selection to the list of recorded selections"
	
	self subclassResponsibility
]

{ #category : 'selection' }
AlbTextEditorSelectionRecorder >> selection [
	"Return current recorded selection"
	<return: #BlSelection>

	^ self subclassResponsibility
]
