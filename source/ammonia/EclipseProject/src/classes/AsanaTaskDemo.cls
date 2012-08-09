public with sharing class AsanaTaskDemo {
	
	public List<SelectOption> apiUsers	 					{get;set;}
	public Id apiUserId										{get;set;}
	public List<SelectOption> apiUserWorkspaces				{get;set;}
	public String apiUserWorkspaceId							{get;set;}
	public List<SelectOption> apiUserWorkspaceProjects		{get;set;}
	public String apiUserWorkspceProjectId					{get;set;}
	public List<SelectOption> apiUserWorkspaceUsers			{get;set;}
	public String apiUserWorkspceUserId						{get;set;}
	
	public String taskAssigneeStatus						{get;set;}
	public String taskCompleted								{get;set;}
	public String taskDueOnMM								{get;set;}
	public String taskDueOnDD								{get;set;}
	public String taskDueOnYYYY								{get;set;}
	public List<String> taskFollowers						{get;set;}
	public String taskName									{get;set;}
	public String taskNotes									{get;set;}
	
	public AsanaTask taskAdded								{get;set;}
	
	public AsanaTaskDemo(){
		apiUsers					= new List<SelectOption>();
		apiUserWorkspaces			= new List<SelectOption>();
		apiUserWorkspaceProjects 	= new List<SelectOption>();
		apiUserWorkspaceUsers 		= new List<SelectOption>();
		taskAdded = null;
		
		apiUsers.add(new SelectOption('', '--Select--'));	
		apiUserWorkspaces.add(new SelectOption('', '--Select--'));
		apiUserWorkspaceProjects.add(new SelectOption('', '--Select--'));
		apiUserWorkspaceUsers.add(new SelectOption('', '--Select--'));	
		
		apiUsersPopulate();
	}
	
	public void apiUsersPopulate(){
		apiUsers = new List<SelectOption>();
		apiUsers.add(new SelectOption('', '--Select--'));
		taskAdded = null;
			
		for(User u : [	select 	Id, Name 
						from 	User 
						where 	Asana_Id__c 		!= null
							and Asana_API_Key__c 	!= null
						limit	:(Limits.getLimitQueryRows() - Limits.getQueryRows())]){
			apiUsers.add(new SelectOption(u.Id, u.Name));	
		}
	}
	
	public PageReference apiUserWorkspacesPopulate(){
		apiUserWorkspaces	= new List<SelectOption>();
		apiUserWorkspaces.add(new SelectOption('', '--Select--'));
		apiUserWorkspaceProjects	= new List<SelectOption>();
		apiUserWorkspaceProjects.add(new SelectOption('', '--Select--'));	
		apiUserWorkspaceUsers	= new List<SelectOption>();	
		apiUserWorkspaceUsers.add(new SelectOption('', '--Select--'));	
		taskAdded = null;	
		
		if(apiUserId != null){
			AsanaUser au = AsanaUserUtility.getAsanaUserSF(apiUserId, apiUserId);
			if(au.workspaces != null){
				for(AsanaWorkspace aw : au.workspaces){
					apiUserWorkspaces.add(new SelectOption(aw.id, aw.name));	
				}
			}
		}
		return null;
	}
	
	public PageReference apiUserWorkspaceProjectsUsersPopulate(){
		apiUserWorkspaceProjects	= new List<SelectOption>();	
		apiUserWorkspaceProjects.add(new SelectOption('', '--Select--'));
		apiUserWorkspaceUsers	= new List<SelectOption>();	
		apiUserWorkspaceUsers.add(new SelectOption('', '--Select--'));	
		taskAdded = null;
			
		if(apiUserId != null && apiUserWorkspaceId != null){	
			for(AsanaProject ap : AsanaWorkspaceUtility.getAsanaProjectList(apiUserWorkspaceId, apiUserId)){
				apiUserWorkspaceProjects.add(new SelectOption(ap.id, ap.name));	
			}
			for(AsanaUser au : AsanaWorkspaceUtility.getAsanaUserList(apiUserWorkspaceId, apiUserId)){
				apiUserWorkspaceUsers.add(new SelectOption(au.id, au.name));	
			}
		}
		return null;
	}
	
	public PageReference addTask(){
		
		Date dueDatetemp = null;
		
		try{
			dueDatetemp = Date.valueOf(taskDueOnYYYY + '-'  + taskDueOnMM + '-' + taskDueOnDD);
		}catch(Exception e){
			dueDatetemp = null;
		}
		
		AsanaTask aTaskWS = 
			AsanaTaskUtility.addTaskToWorkspace(
				apiUserWorkspceUserId, 
				taskAssigneeStatus, 
				(taskCompleted != null ? Boolean.valueOf(taskCompleted) : null), 
				dueDatetemp, 
				taskFollowers, 
				taskName, 
				taskNotes, 
				apiUserWorkspaceId, 
				apiUserId);
				
		taskAdded = aTaskWS;
		
		if(aTaskWS.id != null){
			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Task added to Workspace'));
			
			AsanaTask aTaskProj = 
				AsanaTaskUtility.addTaskToProject(
					aTaskWS, 
					apiUserWorkspceProjectId, 
					apiUserId);	
			
			taskAdded = aTaskProj;	
			
			if(aTaskProj.projects != null && aTaskProj.projects.size() > 0){
				Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Task added to Project'));
							
			}
		}
			
		return null;
		
	}

}