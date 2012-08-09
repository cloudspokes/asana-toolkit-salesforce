/************************************************************************************************************
* Name : ContactController								                                                    *
* Created By : Cloud Challenger														                        *
* Created Date : 19th July 2012														                        *
* Description : This class is controller for a VF page which will allow creating a asana task from UI       *
************************************************************************************************************/
public class AsanaTaskController{
    
    /* Workspace select options of asana account */
    public List<SelectOption> workspaces{get;set;}
    
    /* Assignee select option of asana account */
    public List<SelectOption> assignee{get;set;}
    
    /* Logged-In user asana api key */
    public string apiKey{get;set;}
    
    /* Selected workspace */
    public string selectedWorkspace{get;set;}
    
    /* Selected Assignee */
    public string selectedAssignee{get;set;}
    
     /* Selected followers */
    public string selectedFollowers{get;set;}
    
    /* Asana task note */
    public string notes{get;set;}
    
    /* Asana task name */
    public string name{get;set;}
    
    /* Asana task completed status */
    public boolean completed{get;set;}
    
    /* Asana task status i.e. either inbox, today, later and upcoming */
    public string assigneeStatus{get;set;} 
    
    /* Task to show due on date picker */
    public Task task{get;set;}
    
    /**
     * Getting all the relevant details from Asana using API to be display on Visualforce page
     * This includes workspace details, users etcs     
     */
    public AsanaTaskController(){
        try{
        User user = [select id,Asana_API_Key__c from user where id =: userinfo.getuserId()];
        task = new Task();   
        apiKey =''; 
        if(user.Asana_API_Key__c == null || user.Asana_API_Key__c == ''){
            ApexPages.addMessage(new ApexPages.Message(Apexpages.severity.Error,'Please add asana api key in personal information'));
            return;
        }
        else{	
            apiKey = user.Asana_API_Key__c;
        }
         HttpResponse workspaceResponse = AsanaIntegration.getAllworkspaces(apiKey);
         
         if(workspaceResponse.getStatusCode() == 200){
             workspaces = createSelectOption(workspaceResponse.getBody());
         }
         else{
            showErrors(workspaceResponse.getbody());
         }
         
         HttpResponse userResponse = AsanaIntegration.getAllUsers(apiKey);
         
         if(userResponse.getStatusCode() == 200){
             assignee = new List<SelectOption>{new SelectOption('','--none--')};
             assignee.addAll(createSelectOption(userResponse.getBody()));
         }
         else{
             showErrors(userResponse.getbody());
             return;
         }
        }
        catch(Exception ex){
        	ApexPages.addMessage(new ApexPages.Message(Apexpages.severity.Error,ex.getMessage()));
        }
    }
    
    /**
     * Create a task on the basis of data entered from Visual force page
     */     
    public pagereference createTask(){
    	
    	/* if user selected followers then create list of followers */
    	String[] followers = new String[]{};
    	if(selectedFollowers != '[]'){
    		selectedFollowers = selectedFollowers.substring(1,selectedFollowers.length() - 1 );
    		followers = selectedFollowers.split(', ');
    	}
    	    	
        HttpResponse taskResponse = AsanaIntegration.createTask(selectedAssignee,assigneeStatus,completed,task.ActivityDate,name,notes,selectedWorkspace,followers,apiKey);
        system.debug(taskResponse.getbody());
        
        /* Status code is 201 for task creation */
        if(taskResponse.getStatusCode() == 201){
        	ApexPages.addMessage(new ApexPages.Message(Apexpages.severity.Info,'Task Created Successfully'));
        	resetTaskFields();
        }
        else{
        	showErrors(taskResponse.getbody());
             
        }
        return null;
    }
    
    /**
    * Reset all the task fields
    */
    private void resetTaskFields(){
    		selectedAssignee = '';
    		assigneeStatus = '';
    		completed = false;
    		task.ActivityDate = null;
    		name = '';
    		notes = '';
    		selectedWorkspace = '';
    }
    
    /**
     * Creating apex error message from the error response
     */
    private void showErrors(string errorResponse){
    	List<Errors> errorList = parseErrors(errorResponse);
	     for(Errors errs:errorList){
	     	String errorMsg = errs.message;
	     	errorMsg += errs.phrase == null?'': ': '+errs.phrase;
	     	ApexPages.addMessage(new ApexPages.Message(Apexpages.severity.Error,errorMsg));
	     }
    }
    
    /**
     * Creating option list for User names
     */
    private List<SelectOption> createSelectOption(string response){
        List<WrapperIdName> lst = createListIdName(response);
        List<SelectOption> options = new List<SelectOption>();
        for(WrapperIdName n: lst){
            options.add(new SelectOption(n.Id,n.name));
        }
        return options;
    
    }
    
    class WrapperIdName{
        string id;
        string name;
    }
         
     private static  List<WrapperIdName> createListIdName(string response) {
        List<WrapperIdName> idNameList = new List<WrapperIdName>();
        JSONParser parser = JSON.createParser(response);
        while(parser.nextToken() != null) {
           if(parser.getCurrentToken() == JSONToken.START_ARRAY) {
                   while(parser.nextToken() != null) {
                   if(parser.getCurrentToken() == JSONToken.START_OBJECT) {
                        WrapperIdName idName = (WrapperIdName)parser.readValueAs(WrapperIdName.class);
                        system.debug(idName);
                        idNameList.add(idName);
                    }
                }
            }
        }
        return idNameList;
    }
    
    class Errors{
        string message;
        string phrase;
    }
    
    private static  List<Errors> parseErrors(string response) {
        List<Errors> idNameList = new List<Errors>();
        JSONParser parser = JSON.createParser(response);
        while(parser.nextToken() != null) {
           if(parser.getCurrentToken() == JSONToken.START_ARRAY) {
                   while(parser.nextToken() != null) {
                   if(parser.getCurrentToken() == JSONToken.START_OBJECT) {
                        Errors errs = (Errors)parser.readValueAs(Errors.class);
                        system.debug(errs);
                        idNameList.add(errs);
                    }
                }
            }
        }
        return idNameList;
    }
   
}