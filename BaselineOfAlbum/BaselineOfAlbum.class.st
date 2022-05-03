Class {
	#name : #BaselineOfAlbum,
	#superclass : #BaselineOf,
	#category : #BaselineOfAlbum
}

{ #category : #baselines }
BaselineOfAlbum >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec 
			baseline: 'BlocPac' with: [
				spec repository: 'github://pharo-graphics/bloc-pac:dev-1.0/src' ].

		spec 
			package: #'Album' with: [
				spec repository: 'github://plantec/Album:dresser/src'.
				spec requires: #(#'BlocPac') ]
			 ].
]
