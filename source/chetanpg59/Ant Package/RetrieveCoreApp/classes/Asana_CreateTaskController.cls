/**
 *  @author     Chetan Gupta
 *  @version    1.0
 *  @since      19-July-2012
 */
public with sharing class Asana_CreateTaskController 
{
	public Asana_TaskEntries task {get; set;}
	public Asana_TagEntries tag {get; set;}
	public Asana_ProjectEntries project {get; set;}
	public Asana_UserEntries assignee {get; set;}
	public Asana_UserEntries follower {get; set;}
	public String workspaceId {get; set;}
	public Boolean renderDetails {get; set;}
	
	public Asana_CreateTaskController()
	{
		renderDetails = false;
		task = new Asana_TaskEntries();
		tag = new Asana_TagEntries();
		project = new Asana_ProjectEntries();
		assignee = new Asana_UserEntries();
		follower = new Asana_UserEntries();
	}
	
	public PageReference loadDetails()
	{
		renderDetails = true;
		return null;
	}
	
	public List<SelectOption> getWorkspaceInAsana()
	{
		try
		{
			List<Asana_WorkspaceEntries> workspaces = AsanaRestClient.getAllWorkspaces();
			List<SelectOption> options = new List<SelectOption>();
			options.add(new SelectOption('None','None'));
        	for(Asana_WorkspaceEntries workspace : workspaces)
        	{
        		options.add(new SelectOption(workspace.id,workspace.name));
        	}
        	return options;
		}
		catch(Exception e)
		{
			System.debug(e);
		}
		return null;
	}
	
	public List<SelectOption> getUsersInAsana()
	{
		try
		{
			List<Asana_UserEntries> users = AsanaRestClient.getUsersByWorkspace(workspaceId);
			List<SelectOption> options = new List<SelectOption>();
			options.add(new SelectOption('None','None'));
        	for(Asana_UserEntries user : users)
        	{
        		options.add(new SelectOption(user.id,user.name));
        	}
        	return options;
		}
		catch(Exception e)
		{
			System.debug(e);
		}
		return null;
	}
	
	public List<SelectOption> getProjectsInWorkspace()
	{
		try
		{
			List<Asana_ProjectEntries> projects = AsanaRestClient.getProjectsInWorkspace(workspaceId);
			List<SelectOption> options = new List<SelectOption>();
			options.add(new SelectOption('None','None'));
        	for(Asana_ProjectEntries project : projects)
        	{
        		options.add(new SelectOption(project.id,project.name));
        	}
        	return options;
		}
		catch(Exception e)
		{
			System.debug(e);
		}
		return null;
	}
	
	public List<SelectOption> getTagsInWorkspace()
	{
		try
		{
			List<Asana_TagEntries> tags = AsanaRestClient.getTagsByWorkspace(workspaceId);
			List<SelectOption> options = new List<SelectOption>();
			options.add(new SelectOption('None','None'));
        	for(Asana_TagEntries tag : tags)
        	{
        		options.add(new SelectOption(tag.id,tag.name));
        	}
        	return options;
		}
		catch(Exception e)
		{
			System.debug(e);
		}
		return null;
	}
	
	public PageReference createTask()
	{
		try
		{
			if(task.name == null || task.name == '')
			{
				ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter the task name');
				ApexPages.addMessage(myMsg);
				return null;
			}
			
			if(task.notes == null || task.notes == '')
			{
				ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter the task notes');
				ApexPages.addMessage(myMsg);
				return null;
			}
			
			if(follower.id != null && follower.id != '' && !follower.id.equals('None'))
			{
				List<Asana_UserEntries> followers = new List<Asana_UserEntries>();
				followers.add(follower);
				task.followers = followers;
			}
			
			if(assignee.id != null && assignee.id != '' && !assignee.id.equals('None'))
			{	
				task.assignee = assignee;
			}
			
			if(project.id != null && project.id != '' && !project.id.equals('None'))
			{
				List<Asana_ProjectEntries> projects = new List<Asana_ProjectEntries>();
				projects.add(project);
				task.projects = projects;
			}
			
			if(tag.id != null && tag.id != '' && !tag.id.equals('None'))
			{
				List<Asana_TagEntries> tags = new List<Asana_TagEntries>();
				tags.add(tag);
				task.tags = tags;
			}
			
			Asana_TaskEntries createdTask = AsanaRestClient.createTaskInWorkspace(task,workspaceId);
			
			reset();
			
			return null;
		}
		catch(Exception e)
		{
			System.debug(e);
		}
		return null;
	}
	
	public void reset()
	{
		renderDetails = false;
		tag = new Asana_TagEntries();
		project = new Asana_ProjectEntries();
		follower = new Asana_UserEntries();
		assignee = new Asana_UserEntries();
		task = new Asana_TaskEntries();
		workspaceId = ''; 
	}
}