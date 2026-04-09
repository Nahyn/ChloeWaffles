@tool
extends Control
class_name CreditLineControl

@export var contributor_name := "[CONTRIBUTOR]":
	set(_contributor_name):
		contributor_name = _contributor_name
		$NameLabel.text = contributor_name
@export var resource_name := "[RESOURCE]":
	set(_resource_name):
		resource_name = _resource_name
		$ResourceLinkButton.text = resource_name;
@export var link := "[LINK]":
	set(_link):
		link = _link
		$ResourceLinkButton.uri = _link;
