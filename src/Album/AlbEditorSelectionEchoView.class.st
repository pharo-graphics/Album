Class {
	#name : #AlbEditorSelectionEchoView,
	#superclass : #AlbEditorSelectionView,
	#category : #'Album-UI'
}

{ #category : #accessing }
AlbEditorSelectionEchoView >> borderColor [

	^ Color gray alpha: 0.9
]

{ #category : #accessing }
AlbEditorSelectionEchoView >> borderWidth [
	^ 1
]

{ #category : #accessing }
AlbEditorSelectionEchoView >> selectionColor [
	^ Color lightGray alpha: 0.2
]
