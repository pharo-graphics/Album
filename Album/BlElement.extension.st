Extension { #name : #BlElement }

{ #category : #'*Album' }
BlElement >> actors [
	^ Array streamContents: [ :aStream |
		self viewModelDo: [ :aViewModel | aStream nextPut: aViewModel ].	
		self aptitudeDo: [ :aLook | aStream nextPut: aLook ] ]
]

{ #category : #'*Album' }
BlElement >> aptitude [
	^ self userData at: #aptitude ifAbsent: nil
]

{ #category : #'*Album' }
BlElement >> aptitude: aLook [
	| aLookInstance |
	
	self aptitudeDo: [ :aCurrentLook |
		aCurrentLook onUninstalledIn: self.
		self userData at: #aptitude put: nil ].

	aLookInstance := aLook asLook.

	self userData at: #aptitude put: aLookInstance.
	aLookInstance onInstalledIn: self
]

{ #category : #'*Album' }
BlElement >> aptitudeDo: aBlock [
	self aptitude ifNotNil: aBlock
]

{ #category : #'*Album' }
BlElement >> layoutResizerPropagations [
	^ self userData
		at: #layoutResizerPropagations
		ifAbsentPut: [ AlbLayoutResizerElementPropagations new element: self ]
]

{ #category : #'*Album' }
BlElement >> removeAptitude: aLook [
	self aptitude
		ifNotNil: [
			self aptitude = aLook
				ifTrue: [
					self aptitude onUninstalledIn: self.
					self userData at: #aptitude put: nil ]
				ifFalse: [ self aptitude remove: aLook ] ]
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
BlElement >> viewModel: aBrViewModel [
	self aptitudeDo: [ :aLook | self error: 'View model must be added before look' ].

	self viewModelDo: [ :aCurrentModel |
		aCurrentModel onUninstalledIn: self.
		self userData at: #brickViewModel put: nil ].

	self userData at: #brickViewModel put: aBrViewModel.
	aBrViewModel onInstalledIn: self
]

{ #category : #'*Album' }
BlElement >> viewModelDo: aBlock [
	self userData at: #brickViewModel ifPresent: aBlock
]
