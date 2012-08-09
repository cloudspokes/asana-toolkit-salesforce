/**
 *  @author     Chetan Gupta
 *  @version    1.0
 *  @since      19-July-2012
 */
@isTest(SeeAllData=false)
private class Asana_TestCreateTaskController 
{
    static testMethod void myUnitTest() 
    {
    	Profile p = [SELECT ID FROM PROFILE WHERE NAME = 'System Administrator'];

        User usr = new User(Alias = 'testuser', 
                            Email='testuser@testorg.com',
                            EmailEncodingKey='UTF-8', 
                            LastName='Testing', 
                            LanguageLocaleKey='en_US',
                            LocaleSidKey='en_US', 
                            Profileid = p.Id, 
                            Country='United States',
                            TimeZoneSidKey='America/Los_Angeles', 
                            UserName='mytestuser@mytestorg.org');

        insert usr;
        
        System.runAs(usr)
        {
        	Asana_Config__c config = new Asana_Config__c();
			config.Name = 'API Key';
			config.API_Key__c = 'aas23.112312as35dfas';
			insert config;
        	
	    	Test.startTest();
	    	Test.setCurrentPageReference(Page.Asana_CreateTask);
	   		Asana_CreateTaskController controller = new Asana_CreateTaskController();
	   		
	   		controller.getWorkspaceInAsana();
	   		controller.workspaceId = '123123';
	   		
	   		controller.getProjectsInWorkspace();
	   		controller.getTagsInWorkspace();
	   		controller.getUsersInAsana();
	   		
	   		controller.loadDetails();
	   		System.assertEquals(controller.renderDetails,true);
	   		
	   		controller.task.name = 'Some Task';
	   		controller.task.notes = 'Some Notes';
	   		controller.task.due_on = '2012-07-20';
	   		
	   		controller.tag = Asana_UtilityMethods.getTag();
	   		controller.project = Asana_UtilityMethods.getProject();
	   		controller.assignee = Asana_UtilityMethods.getUser();
	   		controller.follower = Asana_UtilityMethods.getUser();
	   		
	   		controller.createTask();
	   		
	   		controller.task.name = '';
	   		controller.task.notes = '';
	   		controller.createTask();
	   		
	   		controller.task.name = 'Some Task';
	   		controller.task.notes = '';
	   		controller.createTask();
	   		
	   		controller.reset();
	   		System.assertEquals(controller.workspaceId,'');
	   		System.assertEquals(controller.renderDetails,false);
	   		
	   		Test.stopTest();     
        }
    }
}