"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  State a one line summary. For example, ""I represent a paragraph of text"".
sel
For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.


    Implementation Points
"
Class {
	#name : #AlbRBTextStyler,
	#superclass : #AlbTextStylerST80,
	#traits : 'TRBProgramNodeVisitor',
	#classTraits : 'TRBProgramNodeVisitor classTrait',
	#instVars : [
		'parentheseLevel',
		'bracketLevel'
	],
	#category : #'Album-Styler'
}

{ #category : #formatting }
AlbRBTextStyler >> addAttributes: attributes forNode: anRBNode [
	
	"RB bug?"
	(anRBNode start > anRBNode stop)
		ifTrue: [ ^ self ].
	
	self 
		addAttributes: attributes
		from: anRBNode start
		to: anRBNode stop
]

{ #category : #formatting }
AlbRBTextStyler >> addAttributes: attributes from: start to: stop [
	text isEmpty
		ifTrue: [ ^ self ].
	
	
	text attributes: attributes
		from: start
		to: stop
]

{ #category : #formatting }
AlbRBTextStyler >> addStyle: styleSymbol attribute: additionalAttribute forNode: anRBNode [

	self 
		addStyle:styleSymbol
		attributes: { additionalAttribute }
		forNode: anRBNode.
]

{ #category : #formatting }
AlbRBTextStyler >> addStyle: styleSymbol attribute: additionalAttribute from: start to: end [

	self
		addAttributes: (self attributesFor: styleSymbol), {additionalAttribute}
		from: start
		to: end
]

{ #category : #formatting }
AlbRBTextStyler >> addStyle: styleSymbol attributes: additionalAttributes forNode: anRBNode [

	self 
		addAttributes: (self attributesFor: styleSymbol), additionalAttributes 
		forNode: anRBNode
]

{ #category : #formatting }
AlbRBTextStyler >> addStyle: styleSymbol forNode: anRBNode [
	"Style a piece of text that represents a given node for a provided style name"

	self
		addAttributes: (self attributesFor: styleSymbol)
		forNode: anRBNode
]

{ #category : #formatting }
AlbRBTextStyler >> addStyle: aStyleSymbol from: aStart to: anEnd [
	"Style a piece of text from aStart to anEnd for a provided style name"

	self
		addAttributes: (self attributesFor: aStyleSymbol)
		from: aStart
		to: anEnd
]

{ #category : #private }
AlbRBTextStyler >> currentClosedBracketStyleName [
	bracketLevel isZero ifTrue: [ ^ #blockEnd ].
	^ (#blockEnd asString , bracketLevel asString) asSymbol
]

{ #category : #private }
AlbRBTextStyler >> currentClosedParenthesisStyleName [
	parentheseLevel isZero ifTrue: [ ^ #rightParenthesis ].
	^ (#rightParenthesis asString , parentheseLevel asString) asSymbol
]

{ #category : #private }
AlbRBTextStyler >> currentOpenedBracketStyleName [
	bracketLevel isZero ifTrue: [ ^ #blockStart ].
	^ (#blockStart asString , bracketLevel asString) asSymbol
]

{ #category : #private }
AlbRBTextStyler >> currentOpenedParenthesisStyleName [
	parentheseLevel isZero ifTrue: [ ^ #leftParenthesis ].
	^ (#leftParenthesis asString , parentheseLevel asString) asSymbol
]

{ #category : #moldability }
AlbRBTextStyler >> extraStyle: aText ast: ast [
	"override this in subclasses for applying extra styling"
]

{ #category : #formatting }
AlbRBTextStyler >> literalStyleSymbol: aValue [
	aValue isSymbol
		ifTrue: [ ^ #symbol ].
	aValue isString
		ifTrue: [ ^ #string ].
	aValue isCharacter
		ifTrue: [ ^ #character ].
	aValue isNumber
		ifTrue: [ ^ #number ].
	aValue == true
		ifTrue: [ ^ #true ].
	aValue == false
		ifTrue: [ ^ #false ].
	aValue isNil
		ifTrue: [ ^ #nil ].
	^ #default
]

{ #category : #private }
AlbRBTextStyler >> methodOrBlockArgStyleFor: anArgumentNode [
	^ anArgumentNode isBlockVar
		ifTrue: [ #blockArg ]
		ifFalse: [ #methodArg ]
]

{ #category : #private }
AlbRBTextStyler >> methodOrBlockTempDeclStyleFor: aSequenceNode [
	^ aSequenceNode scope isBlockScope
		ifTrue: [ #blockPatternTempVar ]
		ifFalse: [ #patternTempVar ]
]

{ #category : #private }
AlbRBTextStyler >> methodOrBlockTempStyleFor: aTemporaryNode [

	^ aTemporaryNode isDefinedByBlock
		  ifTrue: [ #blockTempVar ]
		  ifFalse: [ #tempVar ]
]

{ #category : #private }
AlbRBTextStyler >> parse: aText isMethod: isMethod [
	|root aString |
	
	aString := aText asString.
	
	isMethod 
		ifTrue: [
			[root := RBParser parseFaultyMethod: aString.
			root methodNode methodClass: classOrMetaClass.
			^root] 
				on: Error 
				do: [^RBParser parseFaultyExpression: aString ]]
		ifFalse:[ ^RBParser parseFaultyExpression: aString ].
]

{ #category : #private }
AlbRBTextStyler >> privateStyle: aText [ 
    | ast |

    ast := self parse: aText isMethod: self isForWorkspace not.
    ast methodNode compilationContext: (CompilationContext new
            class: (classOrMetaClass ifNil: [UndefinedObject]);
				requestor: workspace).
				"Requestor already has support for obtaining the bindings. 
				Adding both the requestor and the bindings creates two scopes
				that are used for looking up variables."
				"bindings: (workspace ifNil: [ Dictionary new ]);"
    ast doSemanticAnalysis.


   self style: aText ast: ast.
	self extraStyle: aText ast: ast.

    ^ aText
]

{ #category : #private }
AlbRBTextStyler >> resolveStyleFor: aVariableNode [

	aVariableNode binding isUndeclaredVariable ifTrue: [ 
		^ (aVariableNode scope hasBindingThatBeginsWith: aVariableNode name)
			  ifTrue: [ #default ]
			  ifFalse: [ #incompleteIdentifier ] ].
	aVariableNode binding ifNil: [ ^ #default ].
	aVariableNode isArgumentVariable ifTrue: [ ^ #methodArg ].
	aVariableNode isTempVariable ifTrue: [ ^ #tempVar ].
	aVariableNode isGlobalVariable ifTrue: [ ^ #globalVar ].
	aVariableNode isInstanceVariable ifTrue: [ ^ #instVar ].
	aVariableNode hasIncompleteIdentifier ifTrue: [ 
		^ #incompleteIdentifier ].
	^ #invalid
]

{ #category : #private }
AlbRBTextStyler >> resolveTextLinkFor: aVariableNode [

	aVariableNode binding isGlobalVariable
		ifTrue: [ ^ BlTextClassLink className: aVariableNode name ].
		
	^ BlTextVariableLink variableName: aVariableNode name
]

{ #category : #private }
AlbRBTextStyler >> style: aText ast: ast [
	text := aText.
	text attributes: (self attributesFor: #default).
	bracketLevel := 0.
	parentheseLevel := 0.
	[ self visitNode: ast ] ensure: [ 
		text := nil ]
]

{ #category : #private }
AlbRBTextStyler >> styleCloseBracket: aBlockNode [
	bracketLevel := bracketLevel - 1.
	(aBlockNode right isZero or: [  aBlockNode value isNil ]) ifTrue:[^ self].
	self addStyle: self currentClosedBracketStyleName from: aBlockNode right to: aBlockNode right
]

{ #category : #private }
AlbRBTextStyler >> styleCloseParenthese: aMessageNode [
	aMessageNode parentheses
		ifNotEmpty: [ 
			aMessageNode parentheses
				reverseDo: [ :interval | 
					| pos |
					pos := interval last.
					parentheseLevel := parentheseLevel - 1.
					self addStyle: self currentClosedParenthesisStyleName from: pos to: pos ] ]
]

{ #category : #private }
AlbRBTextStyler >> styleOpenBracket: aBlockNode [
	| style |
	style := aBlockNode isFaulty
		ifTrue: [ #invalid ]
		ifFalse: [ self currentOpenedBracketStyleName ].
	self addStyle: style from: aBlockNode left to: aBlockNode left.
	bracketLevel := bracketLevel + 1
]

{ #category : #private }
AlbRBTextStyler >> styleOpenParenthese: aMessageNode [
	aMessageNode parentheses
		ifNotEmpty: [ 
			aMessageNode parentheses
				do: [ :interval | 
					| pos |
					pos := interval first.
					self addStyle:  self currentOpenedParenthesisStyleName from: pos to: pos.
					parentheseLevel := parentheseLevel + 1 ] ]
]

{ #category : #private }
AlbRBTextStyler >> styleTempBars: aSequenceNode [
	| tempBarAttribute |
	tempBarAttribute := aSequenceNode scope isMethodScope
		ifTrue: [ #methodTempBar ]
		ifFalse: [ #blockTempBar ].
	aSequenceNode leftBar
		ifNotNil: [ :pos | self addStyle: tempBarAttribute from: pos to: pos ].
	aSequenceNode rightBar
		ifNotNil: [ :pos | self addStyle: tempBarAttribute from: pos to: pos ]
]

{ #category : #moldability }
AlbRBTextStyler >> styledParseCsv: aText [
	| aString indices |
	
	aString := aText asString.
	
	indices := Array streamContents: [ :aStream | '(http|https|file)\:\/\/.+\.(csv)' asRegex
		split: aString
		indicesDo: [ :a :b | aStream nextPut: (a -> b) ] ].

	indices size < 2 ifTrue: [ ^ self ].
	
	aText
		attributes: { BlTextBackgroundAttribute paint: Color yellow }
		from: indices first value + 1
		to: indices second key - 1
]

{ #category : #moldability }
AlbRBTextStyler >> styledParseImage: aText [
	| aString indices |
	
	aString := aText asString.
	
	indices := Array streamContents: [ :aStream | '(http|https)\:\/\/.+\.(png|jpg|jpeg)' asRegex
		split: aString
		indicesDo: [ :a :b | aStream nextPut: (a -> b) ] ].

	indices size < 2 ifTrue: [ ^ self ].
	
	aText
		attributes: { BlTextBackgroundAttribute paint: Color yellow }
		from: indices first value + 1
		to: indices second key - 1
]

{ #category : #'visiting rb nodes' }
AlbRBTextStyler >> visitArgumentNode: anArgumentNode [
	| blockOrMethodArgStyle |
	blockOrMethodArgStyle := self methodOrBlockArgStyleFor: anArgumentNode.
	self addStyle: blockOrMethodArgStyle forNode: anArgumentNode
]

{ #category : #visiting }
AlbRBTextStyler >> visitArgumentNodes: aNodeCollection [ 
	"Sent *once* when visiting method and block nodes"
	^aNodeCollection do: [ :each | self visitArgumentNode: each ]
]

{ #category : #visiting }
AlbRBTextStyler >> visitArrayNode: anArrayNode [ 

	anArrayNode children do: [:each | self visitNode: each]
]

{ #category : #visiting }
AlbRBTextStyler >> visitAssignmentNode: anAssignmentNode [
	self visitNode: anAssignmentNode variable.
	self visitNode: anAssignmentNode value.
	anAssignmentNode variable binding isWritable
		ifFalse: [ self addStyle: #invalid forNode: anAssignmentNode ]
]

{ #category : #'visiting rb nodes' }
AlbRBTextStyler >> visitBlockNode: aBlockNode [
	aBlockNode comments do: [ :comment | self addStyle: #comment from: comment start to: comment stop ].
	aBlockNode arguments do: [ :argument | self addStyle: #blockPatternArg forNode: argument ].
	aBlockNode bar ifNotNil: [ :pos | self addStyle: #blockArgsBar from: pos to: pos ].
	aBlockNode colons do: [ :pos | self addStyle: #blockArgColon from: pos to: pos ].
	self styleOpenBracket: aBlockNode.
	self visitNode: aBlockNode body.
	self styleCloseBracket: aBlockNode
]

{ #category : #'visiting rb nodes' }
AlbRBTextStyler >> visitCascadeNode: aCascadeNode [
	aCascadeNode messages do: [ :each | self visitNode: each ].
	aCascadeNode semicolons do: [ :pos | self addStyle: #cascadeSeparator from: pos to: pos ]
]

{ #category : #visiting }
AlbRBTextStyler >> visitGlobalNode: aSelfNode [
	^ self visitVariableNode: aSelfNode
]

{ #category : #visiting }
AlbRBTextStyler >> visitInstanceVariableNode: aSelfNode [
	^ self visitVariableNode: aSelfNode
]

{ #category : #visiting }
AlbRBTextStyler >> visitLiteralArrayNode: aRBLiteralArrayNode [
	"in a (valid) byte array all elements are of the same type, style the whole contents
at once, but for ordinary literal arrays, style every node"

	(aRBLiteralArrayNode isForByteArray and: [ aRBLiteralArrayNode isFaulty not ])
		ifTrue: [ self addStyle: #literalArray forNode: aRBLiteralArrayNode ]
		ifFalse: [ aRBLiteralArrayNode contents do: [ :each | self visitNode: each ] ]
]

{ #category : #'visiting rb nodes' }
AlbRBTextStyler >> visitLiteralNode: aLiteralNode [
	| value |
	value := aLiteralNode value.
	self 
		addStyle: (self literalStyleSymbol: value)
		attribute: (BlTextClassLink class: value class)
		forNode: aLiteralNode
]

{ #category : #'visiting rb nodes' }
AlbRBTextStyler >> visitMessageNode: aMessageNode [
	| style link |
	style := #keyword.
	(Symbol findInterned: aMessageNode selector asString)
		ifNil: [ 
			style := (Symbol thatStartsCaseSensitive: aMessageNode selector asString skipping: nil) isNil
				ifTrue: [ #undefinedKeyword ]
				ifFalse: [ #incompleteKeyword ] ].
	link := BlTextMethodLink selector: aMessageNode selector.
	self styleOpenParenthese: aMessageNode.
	aMessageNode selectorParts
		with: aMessageNode keywordsPositions
		do: [ :keyword :position | 
			self
				addStyle: style
				attribute: link
				from: position
				to: position + keyword size - 1 ].
	(aMessageNode isCascaded not or: [ aMessageNode isFirstCascaded ])
		ifTrue: [ self visitNode: aMessageNode receiver ].
	aMessageNode arguments do: [ :each | self visitNode: each ].
	self styleCloseParenthese: aMessageNode
]

{ #category : #'visiting rb nodes' }
AlbRBTextStyler >> visitMethodNode: aMethodNode [ 
aMethodNode comments do: [ :comment|
		self 
			addStyle: #comment
			from: comment start
			to: comment stop ].
	aMethodNode arguments do: [ :argument|
		self 
			addStyle: #patternArg
			forNode: argument ].
		
	aMethodNode selectorParts with: aMethodNode keywordsPositions do:  [ :keyword :position |
		self 
			addStyle: #patternKeyword
			from: position
			to: position + keyword size - 1 ].
	
	aMethodNode pragmas
		do: [ :each | self visitNode: each ].
		
	self visitNode: aMethodNode body
]

{ #category : #'visiting rb nodes' }
AlbRBTextStyler >> visitNode: aNode [ 
	aNode comments do: [ :comment|
		self 
			addStyle: #comment
			from: comment start
			to: comment stop ].

	^aNode acceptVisitor: self
]

{ #category : #'visiting rb nodes' }
AlbRBTextStyler >> visitParseErrorNode: anErrorNode [
	self 
		addStyle: #invalid
		forNode: anErrorNode
]

{ #category : #visiting }
AlbRBTextStyler >> visitPatternBlockNode: aRBPatternBlockNode [ 
	self visitArgumentNodes: aRBPatternBlockNode arguments.
	self visitNode: aRBPatternBlockNode body
]

{ #category : #visiting }
AlbRBTextStyler >> visitPatternWrapperBlockNode: aRBPatternWrapperBlockNode [ 
	self visitNode: aRBPatternWrapperBlockNode wrappedNode.
	self visitArgumentNodes: aRBPatternWrapperBlockNode arguments.
	self visitNode: aRBPatternWrapperBlockNode body
]

{ #category : #'visiting rb nodes' }
AlbRBTextStyler >> visitPragmaNode: aPragmaNode [
	aPragmaNode selectorParts with: aPragmaNode keywordsPositions do: [ :keyword : position|
	self 
		addStyle: #pragmaKeyword
		from: position
		to: position + keyword size - 1 ].
	self addStyle: #pragmaKeyword from: aPragmaNode left to: aPragmaNode left.
	self addStyle: #pragmaKeyword from: aPragmaNode right to: aPragmaNode right.	
	aPragmaNode arguments do: [ :each | self visitNode: each ]
]

{ #category : #'visiting rb nodes' }
AlbRBTextStyler >> visitReturnNode: aReturnNode [ 
	self 
		addStyle: #return
		from: aReturnNode start
		to: aReturnNode stop.
		
	self visitNode: aReturnNode value
]

{ #category : #'visiting rb nodes' }
AlbRBTextStyler >> visitSelfNode: aSelfNode [
	self 
		addStyle: #self
		forNode: aSelfNode
]

{ #category : #'visiting rb nodes' }
AlbRBTextStyler >> visitSequenceNode: aSequenceNode [
	| patternTempStyle |
	patternTempStyle := self methodOrBlockTempDeclStyleFor: aSequenceNode.
	self styleTempBars: aSequenceNode.
	aSequenceNode temporaries
		do: [ :temporary | self addStyle: patternTempStyle forNode: temporary ].
	aSequenceNode statements do: [ :each | self visitNode: each ].
	aSequenceNode periods do: [ :pos | self addStyle: #statementSeparator from: pos to: pos ]
]

{ #category : #'visiting rb nodes' }
AlbRBTextStyler >> visitSuperNode: aSuperNode [
	self 
		addStyle: #super
		forNode: aSuperNode
]

{ #category : #'visiting rb nodes' }
AlbRBTextStyler >> visitTemporaryNode: aTemporaryNode [
	| methodOrBlockTempStyle |
	methodOrBlockTempStyle := self methodOrBlockTempStyleFor: aTemporaryNode.
	self addStyle: methodOrBlockTempStyle forNode: aTemporaryNode
]

{ #category : #visiting }
AlbRBTextStyler >> visitTemporaryNodes: aNodeCollection [ 
	"This is triggered when defining the temporaries between the pipes"
	^self visitArgumentNodes: aNodeCollection
]

{ #category : #'visiting rb nodes' }
AlbRBTextStyler >> visitThisContextNode: aThisContextNode [
	self 
		addStyle: #thisContext
		forNode: aThisContextNode
]

{ #category : #'visiting rb nodes' }
AlbRBTextStyler >> visitVariableNode: aVariableNode [
	self 
		addStyle: (self resolveStyleFor: aVariableNode) 
		attribute: (self resolveTextLinkFor:aVariableNode)
		forNode: aVariableNode.
	
	
]
