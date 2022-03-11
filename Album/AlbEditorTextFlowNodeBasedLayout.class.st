Class {
	#name : #AlbEditorTextFlowNodeBasedLayout,
	#superclass : #BlNodeBasedLayout,
	#instVars : [
		'lines',
		'lineSpacing'
	],
	#category : #'Album-Layout'
}

{ #category : #constraints }
AlbEditorTextFlowNodeBasedLayout class >> constraints [
	^ AlbEditorTextFlowLayoutConstraints new
]

{ #category : #geometry }
AlbEditorTextFlowNodeBasedLayout >> findClosestChildOf: anElement to: aPoint [
	<return: #BlElement>
	| aClosestLine |

	aClosestLine := self findClosestLineTo: aPoint.
	^ aClosestLine findClosestChildOf: anElement to: aPoint
]

{ #category : #geometry }
AlbEditorTextFlowNodeBasedLayout >> findClosestLineTo: aPoint [
	<return: #AlbEditorTextFlowLine>
	| aClosestLine aClosestDistance |
	
	aClosestLine := lines.
	aClosestDistance := aClosestLine distanceTo: aPoint.
	
	lines do: [ :eachLine | 
		| eachDistance |
		
		eachDistance := eachLine distanceTo: aPoint.
		eachDistance < aClosestDistance
			ifTrue: [
				aClosestDistance := eachDistance.
				aClosestLine := eachLine ] ].
		
	^ aClosestLine
]

{ #category : #testing }
AlbEditorTextFlowNodeBasedLayout >> hasElements [
	^ lines notNil and: [ lines elements notNil ]
]

{ #category : #testing }
AlbEditorTextFlowNodeBasedLayout >> hasLines [
	^ lines notNil
]

{ #category : #initialization }
AlbEditorTextFlowNodeBasedLayout >> initialize [
	super initialize.
	
	lineSpacing := 0
]

{ #category : #layout }
AlbEditorTextFlowNodeBasedLayout >> layout: aParentLayoutNode [
	| anOffsetX anOffsetY aLeft aTop |

	anOffsetX := aParentLayoutNode padding left.
	anOffsetY := aParentLayoutNode padding top.

	aLeft := anOffsetX.
	aTop := anOffsetY.
	
	lines do: [ :aLine |
		aLine origin: aLeft @ aTop.
		aLine elements do: [ :eachChildNode |
			| aWidth aMarginedTop |
			aLeft := aLeft + eachChildNode margin left.
			aMarginedTop := aTop .
			
			"aChildElement supportsBaseline
				ifTrue: [ aMarginedTop := aMarginedTop + (aLine baseline - aChildElement baselineOffset) ]"
				"ifFalse: [ "aMarginedTop := aMarginedTop + eachChildNode margin top + ((aLine baseline - eachChildNode height) max: 0) "]".
			
			aWidth := eachChildNode width.
			"we computed layout bounds for the element, let it apply it"
			eachChildNode position: (aLeft @ aMarginedTop).
			"offset width for the next element"
			aLeft := aLeft + aWidth + eachChildNode margin right ].
		"prepare values for the next line"
		aLeft := anOffsetX.
		aTop := aTop + aLine height + lineSpacing ].
]

{ #category : #accessing }
AlbEditorTextFlowNodeBasedLayout >> lineSpacing [
	^ lineSpacing
]

{ #category : #accessing }
AlbEditorTextFlowNodeBasedLayout >> lineSpacing: anObject [
	lineSpacing := anObject
]

{ #category : #measure }
AlbEditorTextFlowNodeBasedLayout >> measure: aParentLayoutNode [
	| maxWidth aCurrentLine totalContentWidth totalContentHeight |
	
	"compute how much space is available along both axes"
	maxWidth := (aParentLayoutNode widthSpec isUnspecified
		ifTrue: [ SmallInteger maxVal ]
		ifFalse: [ aParentLayoutNode widthSpec size ]) - aParentLayoutNode padding width.

	"Actually a linked list of lines"
	lines := AlbEditorTextFlowLine new maxWidth: maxWidth.
	
	"measure children and distribute them in lines"
	aCurrentLine := lines.
	aParentLayoutNode childrenDo: [ :eachChildNode |
		self preMeasureChildNode: eachChildNode.
		aCurrentLine := aCurrentLine add: eachChildNode ].

	aCurrentLine pushedQueue do: [ :aPushedElement |
		aCurrentLine := aCurrentLine nextLine.
		aCurrentLine push: aPushedElement ].

	"compute total extent to measure layout's owner element"	
	totalContentWidth := aParentLayoutNode padding width + lines totalWidth.
	totalContentHeight := aParentLayoutNode padding height + lines totalHeight.
	totalContentHeight := totalContentHeight + ((lines count - 1) * lineSpacing).

	aParentLayoutNode extent: (aParentLayoutNode extentSpec sizeFor: totalContentWidth @ totalContentHeight).

	"lines do: [ :aLine |
		aLine elements ifNotEmpty: [ :theElements |
			(theElements last isKindOf: BrTextElementWithCursors)
				ifTrue: [
					theElements last measure: (BlExtentMeasurementSpec exact:
						theElements last measuredExtent + (((anElement measuredWidth - aLine width) max: 0.0) @ theElements last padding height negated)) ] ] ]."
]
