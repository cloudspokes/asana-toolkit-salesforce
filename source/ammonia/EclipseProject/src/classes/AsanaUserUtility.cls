public with sharing class AsanaUserUtility {
	/**
  		Method to get AsanaUser from Asana
		@param User SF Id and API USER SF Id
		@return AsanaUser instance
	*/
	public static AsanaUser getAsanaUserSF(	Id 		sfUserId, 
  											Id 		apiUserId){
		return AsanaUserUtility.getAsanaUser(AsanaUserUtility.getSFUserAsanaUserId(sfUserId), apiUserId);
	}
	
	/**
  		Method to get AsanaUser from Asana
		@param User Asana Id and API USER SF Id
		@return AsanaUser instance
	*/
	public static AsanaUser getAsanaUser(	String 		asanaUserId, 
  											Id 			apiUserId){
		
		return AsanaJsonUtility.getAsanaUserInstance(AsanaUserUtility.getAsanaUserJSON(asanaUserId, apiUserId));
	}
	
	/**
  		Method to get AsanaUser from Asana
		@param User Asana Id and API USER SF Id
		@return JSON Response
	*/
	public static String getAsanaUserJSON(	String 		asanaUserId, 
  											Id 			apiUserId){
		
		String jsonResponse = '';  		
		
		HttpRequest req = new HttpRequest();
		req.setMethod('GET');
		req.setHeader('Authorization','Basic '  + EncodingUtil.base64Encode(Blob.valueOf(AsanaUserUtility.getSFUserAsanaAPIKey(apiUserId) + ':' + '')));  
		req.setEndpoint('https://app.asana.com/api/1.0/users/' + asanaUserId);
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
						'"id":1254154629818,'+
						'"name":"Ammonia",'+
						'"email":"ammonia.cloudspokes@gmail.com",'+
						'"workspaces":['+
							'{'+
								'"id":1254154629823,'+
								'"name":"CloudspokesWorkspace"'+
							'}'+
						']'+
					'}'+
				'}';
		}
		
		return jsonResponse;
	}
	
	/**
  		Method to get Asana Id of a SF User Id
		@param USER SF Id
		@return USER Asana Id
	*/
	public static String getSFUserAsanaUserId(Id userId){
		return AsanaUserUtility.getSFUser(userId).Asana_Id__c;
	}
	
	/**
  		Method to get Asana Key of a SF User Id
		@param USER SF Id
		@return USER Asana Key
	*/
	public static String getSFUserAsanaAPIKey(Id userId){
		try{
			return AsanaUserUtility.getSFUser(userId).Asana_API_Key__c;
		}catch(Exception e){
			return null;
		}
	}
	
	/**
  		Method to get SF User record of a SF User Id
		@param USER SF Id
		@return USER record if Asana_Id__c and Asana_API_Key__c are present
	*/
	public static User getSFUser(Id userId){
		try{
			return	[	select 	Asana_Id__c, Asana_API_Key__c 
						from 	User 
						where 	Id 					 = :userId
							and Asana_Id__c 		!= null
							and Asana_API_Key__c 	!= null
						limit	1];
		}catch(Exception e){
			return null;
		}
	}
	
}