@isTest(seeAllData=false)

public with sharing class AsanaTest {
	
	public static testmethod void coverDemo(){
		List<Profile> profiles = [select Id, Name from Profile where UserType IN('Standard') limit 1];
	 	
	 	User apiUser =
	 		new User(   
	 				alias				 	='apiUser', 
                    email					='apiUser@testorg.com', 
                    emailencodingkey		='UTF-8', 
                    lastname				='apiUser', 
                    languagelocalekey		='en_US', 
                    localesidkey			='en_US', 
                    profileid 				= profiles.get(0).Id, 
                    timezonesidkey			='America/Los_Angeles', 
                    username				='apiUser@testorg.com',
                    
                    Asana_Id__c 			='blah',
                    Asana_API_Key__c		='blah');
	 	
	 	insert apiUser;
	 	
	 	AsanaTaskDemo atd = new AsanaTaskDemo();
		
		atd.apiUserId = apiUser.Id;		
		atd.apiUserWorkspacesPopulate();
		
		atd.apiUserWorkspaceId = '1254154629823';		
		atd.apiUserWorkspaceProjectsUsersPopulate();
		
		atd.apiUserWorkspceProjectId = '1254155398039';
		atd.apiUserWorkspceUserId = '1263368415692';
		
		atd.taskAssigneeStatus = 'later';
		atd.taskCompleted = 'false';
		atd.taskDueOnDD = '05';
		atd.taskDueOnMM = '08';
		atd.taskDueOnYYYY = '2012';
		atd.taskFollowers = new List<String>{'1254154629818', '1263368415692', '1283549757448'};
		atd.taskName = 'Review Challenge 1617';
		atd.taskNotes = 'Its a toolkit';
		atd.addTask();
	}
	
	public static testmethod void coverAsanaClasses(){
		AsanaError ae		= new AsanaError();
        AsanaProject ap 	= new AsanaProject();
        AsanaTag atag 		= new AsanaTag();
        AsanaTask atask 	= new AsanaTask();
        AsanaUser au		= new AsanaUser();
        AsanaWorkspace aw 	= new AsanaWorkspace();
	}

}