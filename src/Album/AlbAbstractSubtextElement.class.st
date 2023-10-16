Class {
	#name : 'AlbAbstractSubtextElement',
	#superclass : 'AlbTextPortionElement',
	#instVars : [
		'editorElement',
		'updateStrategy'
	],
	#category : 'Album-UI-Text-Portion',
	#package : 'Album',
	#tag : 'UI-Text-Portion'
}

{ #category : 'instance creation' }
AlbAbstractSubtextElement class >> editorElement: anEditorElement [

	^ (self basicNew editorElement: anEditorElement)
		  initialize;
		  yourself
]

{ #category : 'initialization' }
AlbAbstractSubtextElement >> defaultGeometry [

	^ BlPolygonGeometry new
]

{ #category : 'initialization' }
AlbAbstractSubtextElement >> defaultUpdateStrategy [

	^ AlbSubtextElementNoUpdateStrategy new.
	

]

{ #category : 'accessing' }
AlbAbstractSubtextElement >> editorElement [

	^ editorElement
]

{ #category : 'accessing' }
AlbAbstractSubtextElement >> editorElement: anEditorElement [

	editorElement := anEditorElement
]

{ #category : 'initialization' }
AlbAbstractSubtextElement >> initialize [ 

	super initialize.
	self geometry: self defaultGeometry.
	self vertices: #().
	self initializeUpdateStrategy
]

{ #category : 'initialization' }
AlbAbstractSubtextElement >> initializeUpdateStrategy [

	self updateStrategy: self defaultUpdateStrategy
	

]

{ #category : 'initialization' }
AlbAbstractSubtextElement >> updateStrategy: aSubTextUpdateStrategy [

	updateStrategy ifNotNil: [ updateStrategy onUninstalledIn: self ].
	updateStrategy := aSubTextUpdateStrategy.
	updateStrategy ifNotNil: [ updateStrategy onInstalledIn: self ].

	

]

{ #category : 'initialization' }
AlbAbstractSubtextElement >> updateVertices [

	self subclassResponsibility 
]

{ #category : 'accessing' }
AlbAbstractSubtextElement >> vertices [

	^ self geometry vertices
]

{ #category : 'accessing' }
AlbAbstractSubtextElement >> vertices: aCollectionOfPoints [

	self geometry: (BlPolygonGeometry new vertices: aCollectionOfPoints).
]

{ #category : 'configuration' }
AlbAbstractSubtextElement >> withExtentChangeAdaption [

	self updateStrategy: AlbSubtextElementUpdateOnExtentChangeStrategy new
]

{ #category : 'configuration' }
AlbAbstractSubtextElement >> withoutAdaption [

	self updateStrategy: AlbSubtextElementNoUpdateStrategy new
]
