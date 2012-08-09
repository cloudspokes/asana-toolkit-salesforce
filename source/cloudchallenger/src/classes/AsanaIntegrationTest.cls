/************************************************************************************************************
* Name : AsanaIntegrationTest								                                                *
* Created By : Cloud Challenger														                        *
* Created Date : 19th July 2012														                        *
* Description : This test class test the functionality of AsanaIntegration class          	                *
************************************************************************************************************/

@isTest
public class AsanaIntegrationTest{

	/**
	* Test getAllWorkspaces method 
	*/
    public static testmethod void testGetAllWorkspaces(){
        Test.startTest();
        HttpResponse res = AsanaIntegration.getAllWorkspaces('1234');
        Test.stopTest();
        System.AssertEquals(200,res.getStatusCode());
    }
    
    /**
	* Test getAllWorkspaces method with error
	*/
    public static testmethod void testGetAllWorkspacesWithError(){
        Test.startTest();
        HttpResponse res = AsanaIntegration.getAllWorkspaces('error');
        Test.stopTest();
        System.AssertNotEquals(200,res.getStatusCode());
    }
    
    /**
	* Test getAllUsers method 
	*/
    public static testmethod void testGetAllUsers(){
        Test.startTest();
        HttpResponse res = AsanaIntegration.getAllUsers('1234');
        Test.stopTest();
        System.AssertEquals(200,res.getStatusCode());
    }
    
    /**
	* Test getAllUsers method with error
	*/
    public static testmethod void testGetAllUsersWithError(){
        Test.startTest();
        HttpResponse res = AsanaIntegration.getAllUsers('error');
        Test.stopTest();
        System.AssertNotEquals(200,res.getStatusCode());
    }
    
    /**
	* Test createTask method 
	*/
    public static testmethod void testCreateTask(){
        Test.startTest();
        HttpResponse res = AsanaIntegration.createTask('234','inbox',false,date.today(),'test sfdc','Test SFDC','234',new String[]{},'mrumTMS');
        Test.stopTest();
        System.AssertEquals(201,res.getStatusCode());
    }
    
    /**
	* Test createTask method with error
	*/
    public static testmethod void testCreateTaskWithError(){
        Test.startTest();
        HttpResponse res = AsanaIntegration.createTask('234','inbox',false,date.today(),'test sfdc','Test SFDC','234',new String[]{},'error');
        Test.stopTest();
        System.AssertNotEquals(201,res.getStatusCode());
    }
    
    /**
	* Test sendHttp method 
	*/
    public static testmethod void testSendHttp(){
        Test.startTest();
        HttpResponse res = AsanaIntegration.sendHttp('test','GET','Body','Test');
        Test.stopTest();
        System.AssertEquals(200,res.getStatusCode());
    }
}