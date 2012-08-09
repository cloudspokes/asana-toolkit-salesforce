/**
  	Asana User class resembling Asana User from Asana API
*/
public with sharing class AsanaUser {
	public String				id			; 
	public String				email		; 
	public String				name		; 
	public List<AsanaWorkspace>	workspaces	; 
  	public List<AsanaError>		errors		; 
}