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
AlbEditorSelectionEchoView >> selectionColor [
	^ Color veryLightGray alpha: 0.1
]
