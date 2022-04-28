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
			baseline: 'NewBlocPac' with: [
				spec repository: 'github://pharo-graphics/bloc-pac/src' ].

		spec 
			package: #'Album' with: [
				spec requires: #(#'NewBlocPac') ]
			 ].
]
