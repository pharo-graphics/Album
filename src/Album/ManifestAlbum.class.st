"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestAlbum,
	#superclass : #PackageManifest,
	#category : #'Album-Manifest'
}

{ #category : #'code-critics' }
ManifestAlbum class >> ruleAnySatisfyRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#AlbSelectionSideDecoration #selectionLimitRectangleOf:in: #false)) #'2022-08-30T23:11:35.989869+02:00') )
]
