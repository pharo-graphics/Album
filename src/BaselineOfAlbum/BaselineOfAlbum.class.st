Class {
	#name : #BaselineOfAlbum,
	#superclass : #BaselineOf,
	#category : #BaselineOfAlbum
}

{ #category : #baselines }
BaselineOfAlbum >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		spec
			baseline: 'OnBloc'
			with: [ spec repository: 'github://plantec/OnBloc/src' ].

		spec package: #Album with: [ 
			spec repository: 'github://plantec/Album/src'.
			spec requires: #( #OnBloc ) ].
		spec package: #'Album-Sparta' with: [ 
			spec repository: 'github://plantec/Album/src'.
			spec requires: #( #OnBloc #'Bloc-Sparta' ) ].
		spec
			package: #'#Album-Tests' with: [ spec requires: #( #Album ) ];
			package: #'Album-Examples' with: [ spec requires: #( #Album ) ];
			package: #'Album-Brick-NU' with: [ spec requires: #( #Album ) ] ]
]
