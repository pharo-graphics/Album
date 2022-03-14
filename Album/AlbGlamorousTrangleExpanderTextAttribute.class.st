Class {
	#name : #AlbGlamorousTrangleExpanderTextAttribute,
	#superclass : #AlbTextExpandButtonAttribute,
	#instVars : [
		'id'
	],
	#category : #'Album-Brick-Glamorous'
}

{ #category : #accessing }
AlbGlamorousTrangleExpanderTextAttribute >> doAffect: aTBrTextEditorTextualPiece in: anEditorElement [
	| aToggle |

	aToggle := BrTriangle new
		id: self id;
		aptitude: BrGlamorousTriangleInCircleAptitude;
		expanded: self isExpanded;
		padding: (BlInsets all: 2);
		margin: (BlInsets top: 2);
		mouseCursor: BlCursor default;
		toggleAction: [
			self
				toggleExpandedOrCollapsedAttributesOn: aTBrTextEditorTextualPiece
				in: anEditorElement editor ].
		
	self
		applyExpandedOrCollapsedAttributesOn: aTBrTextEditorTextualPiece
		in: anEditorElement editor.

	^ aToggle
]

{ #category : #accessing }
AlbGlamorousTrangleExpanderTextAttribute >> id [
	<return: #BlElementId>
	
	^ id
]

{ #category : #accessing }
AlbGlamorousTrangleExpanderTextAttribute >> id: anElementId [
	id := anElementId
]

{ #category : #accessing }
AlbGlamorousTrangleExpanderTextAttribute >> initialize [
	super initialize.
	
	id := BlElementId noId
]
