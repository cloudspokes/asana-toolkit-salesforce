/************************************************************************************************************
* Name : AsanaTaskControllerTest								                                            *
* Created By : Cloud Challenger														                        *
* Created Date : 19th July 2012														                        *
* Description : This test class test the functionality of AsanaTaskController class          	            *
************************************************************************************************************/

@isTest
public class AsanaTaskControllerTest{

	/**
	* Test createTask action
	*/
	public static testmethod void testCreateTask(){
        User u = new User(ID = userinfo.getUserId());
        u.Asana_API_Key__c ='Test';
        update u;
        AsanaTaskController controller = new AsanaTaskController();
        controller.assigneeStatus = 'Test';
        controller.name = 'Test task Name';
        controller.notes = 'Test notes';
        controller.selectedWorkspace ='Test workspace';
        controller.selectedFollowers = '[123545]';
        Test.startTest();
        controller.createTask();
        Test.stopTest();
		System.assertEquals(1,ApexPages.getMessages().size());
		System.assertEquals('Task Created Successfully',ApexPages.getMessages()[0].getSummary());
    }
    
    /**
	* Test createTask action with error
	*/
    public static testmethod void testCreateTaskWithError(){
        User u = new User(ID = userinfo.getUserId());
        u.Asana_API_Key__c ='error';
        update u;
        AsanaTaskController controller = new AsanaTaskController();
        controller.assigneeStatus = 'Test';
        controller.name = 'Test task Name';
        controller.notes = 'Test notes';
        controller.selectedWorkspace = 'Test workspace';
        controller.selectedFollowers = '[]';
        Test.startTest();
        controller.createTask();
        Test.stopTest();
		System.assertEquals(1,ApexPages.getMessages().size());
		System.assertNotEquals('Task Created Successfully',ApexPages.getMessages()[0].getSummary());
    }
    
    /**
	* Test createTask action witn no api key present in current user
	*/
    public static testmethod void testCreateTaskWithNoAPIKey(){
        User u = new User(ID = userinfo.getUserId());
        u.Asana_API_Key__c ='';
        update u;
        Test.startTest();
        AsanaTaskController controller = new AsanaTaskController();
        Test.stopTest();
		System.assertEquals(1,ApexPages.getMessages().size());
		System.assertNotEquals('Task Created Successfully',ApexPages.getMessages()[0].getSummary());
    }
    
}