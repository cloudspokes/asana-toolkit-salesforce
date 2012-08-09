/**
  	Asana Project class resembling Asana Project from Asana API
*/
public with sharing class AsanaProject {
	public String				id				;
	public String				archived		;
	public String				created_at		;
  	public List<AsanaUser>		followers		;
  	public String				modified_at		;
  	public String				name			;
  	public String				notes			;
  	public AsanaWorkspace		workspace		;
  	public List<AsanaError>		errors			;   	
}