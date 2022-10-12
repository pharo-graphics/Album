Class {
	#name : #AlbTextEditorMode,
	#superclass : #Object,
	#instVars : [
		'eventHandlers',
		'shortcuts',
		'readonly',
		'allowSelection'
	],
	#category : #'Album-Brick-NU-Album-Model'
}

{ #category : #'text - copying' }
AlbTextEditorMode class >> editable [

	^ self new readonly: false
]

{ #category : #'text - copying' }
AlbTextEditorMode class >> readonly [

	^ self new readonly: true
]

{ #category : #'text - copying' }
AlbTextEditorMode class >> readonlyWithSelection [

	^ self new readonly: true
]

{ #category : #'text - copying' }
AlbTextEditorMode class >> readonlyWithoutSelection [

	^ self new
		  readonly: true;
		  allowSelection: false;
		  yourself
]

{ #category : #'api - hooks' }
AlbTextEditorMode >> installOnEditor: aTextEditor [


]

{ #category : #'api - hooks' }
AlbTextEditorMode >> installOnEditorElement: anEditorElement [


]

{ #category : #'api - hooks' }
AlbTextEditorMode >> uninstallFromEditor: aTextEditor [

	
]

{ #category : #'api - hooks' }
AlbTextEditorMode >> uninstallFromEditorElement: anEditorElement [

	
]
