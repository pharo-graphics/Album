Extension { #name : #BlElement }

{ #category : #'*Album' }
BlElement >> asStencil [
	^ self
]

{ #category : #'*Album' }
BlElement >> dresser [
	^ self userData at: #dresser ifAbsent: nil
]

{ #category : #'*Album' }
BlElement >> dresser: aDresser [
	| installed |
	
	self dresserDo: [ :currDresser |
		currDresser onUninstalledIn: self.
		self userData at: #dresser put: nil ].

	installed := aDresser asLook.

	self userData at: #dresser put: installed.
	installed onInstalledIn: self
]

{ #category : #'*Album' }
BlElement >> dresserDo: aBlock [
	self dresser ifNotNil: aBlock
]

{ #category : #'*Album-Theme' }
BlElement >> theme [
	^ self userData
		at: #AlbTheme
		ifAbsent: [ self hasParent
				ifTrue: [ self parent theme ]
				ifFalse: [ AlbTheme default ] ]
]

{ #category : #'*Album-Theme' }
BlElement >> theme: aTheme [
	self userData at: #AlbTheme put: aTheme.
	self properties
		addProperty:
			(AlbThemeElementProperty new
				theme: aTheme;
				yourself)
]

{ #category : #'*Album' }
BlElement >> viewModel [
	^ self userData at: #brickViewModel ifAbsent: nil
]

{ #category : #'*Album' }
BlElement >> viewModel: aViewModel [
	self aptitudeDo: [ :aLook | self error: 'View model must be added before look' ].

	self viewModelDo: [ :aCurrentModel |
		aCurrentModel onUninstalledIn: self.
		self userData at: #brickViewModel put: nil ].

	self userData at: #brickViewModel put: aViewModel.
	aViewModel onInstalledIn: self
]

{ #category : #'*Album' }
BlElement >> viewModelDo: aBlock [
	self userData at: #brickViewModel ifPresent: aBlock
]

{ #category : #'*Album' }
BlElement >> widgetContent [

	^ self
		  directChildNamed: #content
		  ifFound: [ :anElement | anElement ]
		  ifNone: [ self ]
]
