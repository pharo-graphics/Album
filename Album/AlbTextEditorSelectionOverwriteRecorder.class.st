Class {
	#name : #AlbTextEditorSelectionOverwriteRecorder,
	#superclass : #AlbTextEditorSelectionRecorder,
	#instVars : [
		'compositeSelection'
	],
	#category : #'Album-Model-Selection'
}

{ #category : #selection }
AlbTextEditorSelectionOverwriteRecorder >> commit: aTextEditor [
	"Commit recorded selection intervals in a given text editor"
	
	aTextEditor selection: (BlCompositeSelection new add: self selection).
	aTextEditor updateSelection: 1 to: aTextEditor text size.

	compositeSelection := BlCompositeSelection new
]

{ #category : #selection }
AlbTextEditorSelectionOverwriteRecorder >> deselect: aMonotoneTextSelection in: aTextEditor [

	(AlbTextEditorRecordDeselectionSignal new selection: aMonotoneTextSelection) emit.

	compositeSelection remove: aMonotoneTextSelection.
	aTextEditor updateSelection: aMonotoneTextSelection from to: aMonotoneTextSelection to
]

{ #category : #initialization }
AlbTextEditorSelectionOverwriteRecorder >> initialize [
	super initialize.
	
	compositeSelection := BlCompositeSelection new
]

{ #category : #selection }
AlbTextEditorSelectionOverwriteRecorder >> prepare: aTextEditor [
	
	compositeSelection := BlCompositeSelection new.

	aTextEditor selectNone
]

{ #category : #selection }
AlbTextEditorSelectionOverwriteRecorder >> select: aMonotoneTextSelection in: aTextEditor [
	"Add a given selection to the list of recorded selections"
	
	(AlbTextEditorRecordSelectionSignal new selection: aMonotoneTextSelection) emit.

	compositeSelection add: aMonotoneTextSelection.
	aTextEditor updateSelection: aMonotoneTextSelection from to: aMonotoneTextSelection to
]

{ #category : #selection }
AlbTextEditorSelectionOverwriteRecorder >> selection [
	<return: #BlSelection>

	^ compositeSelection isEmpty
		ifTrue: [ BlSelection empty ]
		ifFalse: [ BlMonotoneSelection from: compositeSelection from to: compositeSelection to ]
]
