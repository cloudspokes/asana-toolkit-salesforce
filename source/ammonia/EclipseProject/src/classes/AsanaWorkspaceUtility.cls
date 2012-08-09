public with sharing class AsanaWorkspaceUtility {
	/**
  		Method to get List of AsanaProject from Asana for a Workspace
		@param Workspce Id and API USER SF Id
		@return List of AsanaProject instance
	*/
	public static List<AsanaProject> getAsanaProjectList(	String 	workspaceId, 
  															Id		apiUserId){
  		return AsanaJsonUtility.getAsanaProjectInstanceList(AsanaWorkspaceUtility.getAsanaProjectListJSON(workspaceId, apiUserId));										
  	}
  	
  	/**
  		Method to get List of AsanaUser from Asana for a Workspace
		@param Workspce Id and API USER SF Id
		@return List of AsanaUser instance
	*/
	public static List<AsanaUser> getAsanaUserList(	String 	workspaceId, 
  													Id		apiUserId){
  		return AsanaJsonUtility.getAsanaUserInstanceList(AsanaWorkspaceUtility.getAsanaUserListJSON(workspaceId, apiUserId));										
  	}
	
	/**
  		Method to get List of Asana Project from Asana for a Workspace
		@param Workspce Id and API USER SF Id
		@return JSON Response
	*/
	public static String getAsanaProjectListJSON(	String 	workspaceId, 
  													Id		apiUserId){
  		String jsonResponse = '';  		
  		
  		HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint('https://app.asana.com/api/1.0/workspaces/' + workspaceId + '/projects');        
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
					'"data":['+
						'{'+
							'"id":1254155398039,'+
							'"name":"Challenges"'+
						'},'+
						'{'+
							'"id":1283627893277,'+
							'"name":"Customers"'+
						'},'+
						'{'+
							'"id":1283627893286,'+
							'"name":"Funds"'+
						'}'+
					']'+
				'}';
		}
		
        return jsonResponse;
  	}
  	
  	/**
  		Method to get List of Asana User from Asana for a Workspace
		@param Workspce Id and API USER SF Id
		@return JSON Response
	*/
	public static String getAsanaUserListJSON(	String 	workspaceId, 
  												Id		apiUserId){
  		String jsonResponse = '';  		
  		
  		HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint('https://app.asana.com/api/1.0/workspaces/' + workspaceId + '/users');        
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
					'"data": ['+
						'{'+
							'"id": 1263368415692,'+
							'"name": "Asana1"'+
						'},'+
						'{'+
							'"id": 1283549757448,'+
							'"name": "Asana2"'+
						'},'+
						'{'+
							'"id": 1254154629818,'+
							'"name": "Ammonia"'+
						'}'+
					']'+
				'}';
		}
				
        return jsonResponse;
  	}
}