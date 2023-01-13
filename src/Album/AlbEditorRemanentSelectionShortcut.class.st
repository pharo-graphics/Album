Class {
	#name : #AlbEditorRemanentSelectionShortcut,
	#superclass : #AlbEditorShortcut,
	#category : #'Album-Shortcuts'
}

{ #category : #accessing }
AlbEditorRemanentSelectionShortcut >> description [
	^ 'Set the current selection as a remanent one'
]

{ #category : #initialization }
AlbEditorRemanentSelectionShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination primaryE
]

{ #category : #accessing }
AlbEditorRemanentSelectionShortcut >> name [
	^ 'Set remanent selection'
]

{ #category : #evaluation }
AlbEditorRemanentSelectionShortcut >> performOnEditor: aTextEditor element: aEditorElement dueTo: aShortcutEvent [

	aTextEditor dispatchEvent: AlbRemanentUpdateRequest new
]
