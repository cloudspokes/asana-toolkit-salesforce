public with sharing class AsanaTaskUtility {
	/**
		Method to add task in Asana
		@param takes raw parameters of Task and API User SF ID
		@return AsanaTask instance
	*/
	public static AsanaTask addTaskToWorkspace(	String		assigneeId, 
	  											String		assignee_status,
	  											Boolean		completed,
	  											Date		due_on,
	  											String[]	followerIds,
	  											String		name,
	  											String		notes,
	  											String		workspaceId,
  												Id 			apiUserId){
  		return AsanaTaskUtility.addTaskToWorkspace(AsanaTaskUtility.getTaskInstanceFromParam(assigneeId,assignee_status,completed,due_on,followerIds,name,notes,workspaceId), apiUserId);
  	}
  	
  	/**
  		Method to add task in Asana
		@param takes AsanaTask instance parameters of Task and API User SF ID
		@return AsanaTask instance
	*/
	public static AsanaTask addTaskToWorkspace(	AsanaTask 	aTask,
  												Id 			apiUserId){
  		return AsanaJsonUtility.getAsanaTaskInstance(AsanaTaskUtility.addTaskToWorkspaceJSON(aTask, apiUserId));
  	}
  	
  	/**
  		Method to add task in Asana
		@param takes AsanaTask instance parameters of Task and API User SF ID
		@return JSON Response
	*/
	public static String addTaskToWorkspaceJSON(AsanaTask 	aTask, 
  												Id 			apiUserId){
  		String jsonResponse = '';  		
  		
  		String body = 	'';
  		if(aTask.assignee.id != null){
  			body += 'assignee='		+ aTask.assignee.id;
  		}
  		if(aTask.workspace.id != null){
  			body += '&workspace='	+ aTask.workspace.id;
  		}
  		if(aTask.name != null){
  			body += '&name=' + 	EncodingUtil.urlEncode(aTask.name, 'UTF-8') ;
  		}
  		if(aTask.notes != null){
  			body += '&notes=' + 	EncodingUtil.urlEncode(aTask.notes, 'UTF-8') ;
  		}
  		if(aTask.assignee_status != null){
  			body += '&assignee_status='		+ aTask.assignee_status;
  		}
  		if(aTask.completed != null){
  			body += '&completed='			+ aTask.completed;
  		}
  		if(aTask.due_on != null){
  			body += '&due_on='				+ aTask.due_on;
  		}
        if(aTask.followers != null && aTask.followers.size() > 0){
        	body += '&followers=';	
        	String foll ='';
        	for(AsanaUser au : aTask.followers){
        		foll += ',' + au.id ;
        	}
        	foll = foll.replaceFirst(',', '');
        	body += foll;
        }
        
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint('https://app.asana.com/api/1.0/tasks');        
        req.setHeader('Authorization','Basic '  + EncodingUtil.base64Encode(Blob.valueOf(AsanaUserUtility.getSFUserAsanaAPIKey(apiUserId) + ':' + '')));  
        req.setBody(body);
        req.setTimeout(60000);
        
        Http http = new Http(); 
		HttpResponse res;
		if(!Test.isRunningTest()){
			res = http.send(req);				
		}
		if(!Test.isRunningTest()){
			jsonResponse = res.getBody();		
		}else{
			jsonResponse = 
				'{'+
					'"data":{'+
						'"id":1288398561570,'+
						'"created_at":"2012-07-19T09:34:46.820Z",'+
						'"modified_at":"2012-07-19T09:34:46.820Z",'+
						'"name":"ReviewChallenge1617",'+
						'"notes":"Itsatoolkit",'+
						'"completed":false,'+
						'"assignee_status":"later",'+
						'"completed_at":null,'+
						'"due_on":"2012-08-05",'+
						'"workspace":{'+
							'"id":1254154629823,'+
							'"name":"CloudspokesWorkspace"'+
						'},'+
						'"projects":[],'+
						'"tags":[],'+
						'"assignee":{'+
							'"id":1263368415692,'+
							'"name":"Asana1"'+
						'},'+
						'"followers":['+
							'{'+
								'"id":1254154629818,'+
								'"name":"Ammonia"'+
							'},'+
							'{'+
								'"id":1263368415692,'+
								'"name":"Asana1"'+
							'},'+
							'{'+
								'"id":1283549757448,'+
								'"name":"Asana2"'+
							'}'+
						']'+
					'}'+
				'}';
		}
		
        return jsonResponse;
  	}
  	
  	/**
	*/
	public static AsanaTask addTaskToProject(	AsanaTask 	aTask,
  											 	String		projectId,
  												Id 			apiUserId){
  		return AsanaJsonUtility.getAsanaTaskInstance(AsanaTaskUtility.addTaskToProjectJSON(aTask, projectId, apiUserId));	
  	}
  	
  	/**
	*/
	public static String addTaskToProjectJSON(	AsanaTask 	aTask,
  												String		projectId,
  												Id 			apiUserId){
  		HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint('https://app.asana.com/api/1.0/tasks/' + aTask.id + '/addProject');        
        req.setHeader('Authorization','Basic '  + EncodingUtil.base64Encode(Blob.valueOf(AsanaUserUtility.getSFUserAsanaAPIKey(apiUserId) + ':' + '')));  
        req.setBody('project=' + projectId);
        req.setTimeout(60000);
        
        Http http = new Http(); 
		HttpResponse res;
		if(!Test.isRunningTest()){
			res = http.send(req);				
		}
		
		return getTaskFromAsana(aTask.id, apiUserId);	
  	}
  	
  	/**
  		Method to get Task from Asana
		@param takes task id and API USER SF Id
		@return JSON response
	*/
	public static String getTaskFromAsana(	String 	taskId, 
  											Id		apiUserId){
  		String jsonResponse = '';  		
  		
  		HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint('https://app.asana.com/api/1.0/tasks/' + taskId);        
        req.setHeader('Authorization','Basic '  + EncodingUtil.base64Encode(Blob.valueOf(AsanaUserUtility.getSFUserAsanaAPIKey(apiUserId) + ':' + '')));  
        req.setTimeout(60000);
        
        Http http = new Http(); 
		HttpResponse res;
		if(!Test.isRunningTest()){
			res = http.send(req);				
		}
		
		if(!Test.isRunningTest()){
			jsonResponse = res.getBody();		
		}else{
			jsonResponse = 
				'{'+
					'"data":{'+
						'"id":1283780234439,'+
						'"tags":[],'+
						'"created_at":"2012-07-18T18:09:16.086Z",'+
						'"modified_at":"2012-07-18T18:09:16.086Z",'+
						'"name":"ReviewChallenge1617",'+
						'"notes":"Itsatoolkit",'+
						'"completed":false,'+
						'"assignee_status":"later",'+
						'"due_on":"2012-08-05",'+
						'"projects":['+
							'{'+
								'"id":1254155398039,'+
								'"name":"Challenges"'+
							'}'+
						'],'+
						'"workspace":{'+
							'"id":1254154629823,'+
							'"name":"CloudspokesWorkspace"'+
						'},'+
						'"completed_at":null,'+
						'"assignee":{'+
							'"id":1263368415692,'+
							'"name":"Asana1"'+
						'},'+
						'"followers":['+
							'{'+
								'"id":1254154629818,'+
								'"name":"Ammonia"'+
							'},'+
							'{'+
								'"id":1263368415692,'+
								'"name":"Asana1"'+
							'},'+
							'{'+
								'"id":1283549757448,'+
								'"name":"Asana2"'+
							'}'+
						']'+
					'}'+
				'}';
		}
        return jsonResponse;
  	}
  	
  	/**
  		Method to create AsanaTask instance
		@param takes raw parameters of Task
		@return AsanaTask instance
	*/
	public static AsanaTask getTaskInstanceFromParam(	String		assigneeId, 
			  											String		assignee_status,
			  											Boolean		completed,
			  											Date		due_on,
			  											String[]	followerIds,
			  											String		name,
			  											String		notes,
			  											String		workspaceId){
		AsanaUser assignee = new AsanaUser();
  		if(assigneeId != null){
  			assignee.id = assigneeId;
  		}
  		
  		List<AsanaUser> followers = new List<AsanaUser>();
  		if(followerIds != null){
	  		AsanaUser follower;
	  		for(String followerId : followerIds){
	  			if(followerId != null && followerId != 'null' && followerId != ''){
		  			follower = new AsanaUser();
		  			follower.id = followerId;
		  			followers.add(follower);
	  			}
	  		}
  		}
  		
  		AsanaWorkspace workspace = new AsanaWorkspace();
  		if(workspaceId != null){
  			workspace.id = workspaceId;
  		}
  		
  		AsanaTask aTask 		= new AsanaTask();
  		aTask.assignee 			= assignee;
  		aTask.assignee_status 	= assignee_status;
  		aTask.completed			= (completed != null ? String.valueOf(completed) : null);
  		aTask.due_on			= (due_on != null ? String.valueOf(due_on) : null);
  		aTask.followers			= followers;
  		aTask.name				= name;
  		aTask.notes				= notes;
  		aTask.workspace			= workspace;
  		
  		return aTask;  												
	}
}