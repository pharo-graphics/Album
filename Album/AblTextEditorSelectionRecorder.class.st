Class {
	#name : #AblTextEditorSelectionRecorder,
	#superclass : #Object,
	#category : #'Album-Model-Selection'
}

{ #category : #selection }
AblTextEditorSelectionRecorder >> commit: aTextEditor [
	"Commit recorded selection intervals in a given text editor"
	
	self subclassResponsibility
]

{ #category : #selection }
AblTextEditorSelectionRecorder >> deselect: aMonotoneTextSelection in: aTextEditor [
	"Remove a given selection from recorded selections"
	
	self subclassResponsibility
]

{ #category : #selection }
AblTextEditorSelectionRecorder >> prepare: aTextEditor [
	"Prepare recorder for accepting selection intervals"
	
	^ self subclassResponsibility
]

{ #category : #selection }
AblTextEditorSelectionRecorder >> select: aMonotoneTextSelection in: aTextEditor [
	"Add a given selection to the list of recorded selections"
	
	self subclassResponsibility
]

{ #category : #selection }
AblTextEditorSelectionRecorder >> selection [
	"Return current recorded selection"
	<return: #BlSelection>

	^ self subclassResponsibility
]
