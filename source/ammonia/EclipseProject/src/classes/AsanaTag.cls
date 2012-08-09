/**
  	Asana Tag class resembling Asana Tag from Asana API
*/
public with sharing class AsanaTag {
	public String				id				;
	public String				created_at		;
  	public List<AsanaUser>		followers		;
  	public String				name			;
  	public String				notes			;
  	public AsanaWorkspace		workspace		; 
  	public List<AsanaError>		errors			;  	
}