/**
  	Asana Task class resembling Asana Task from Asana API
*/
public with sharing class AsanaTask {
	public String				id				{get;set;} 
	public AsanaUser			assignee		{get;set;} 
  	public String				assignee_status	{get;set;}
  	public String				created_at		{get;set;}
  	public String				completed		{get;set;}
  	public String				completed_at	{get;set;}
  	public String				due_on			{get;set;}
  	public List<AsanaUser>		followers		{get;set;}
  	public String				modified_at		{get;set;}
  	public String				name			{get;set;}
  	public String				notes			{get;set;}
  	public List<AsanaProject>	projects		{get;set;}
  	public List<AsanaTag>		tags			{get;set;}
  	public AsanaWorkspace		workspace		{get;set;}
  	public List<AsanaError>		errors			{get;set;}  	
}