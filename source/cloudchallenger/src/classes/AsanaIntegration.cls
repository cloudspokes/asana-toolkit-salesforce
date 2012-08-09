/************************************************************************************************************
* Name : AsanaIntegration								                                                    *
* Created By : Cloud Challenger														                        *
* Created Date : 19th July 2012														                        *
* Description : This class is utility class used to integrate with Asana API            	                *
************************************************************************************************************/

public class AsanaIntegration{
	/**
	 * Asana End point URL for api.
	 * this can be moved to custom setting afterwards so that
	 * user can change it with latest URI when new version is released
	 */
    static string asanaEndPoint = 'https://app.asana.com/api/1.0';
    
    /**
     * Create a new task using Asana API
     */
    public static HttpResponse createTask(string assignee,string assignee_status,boolean completed,date due_on,string name,string notes,string workspace, string[] followers,string apiKey){
        NewTask newTask = new NewTask(assignee,assignee_status,completed,due_on,name,notes,followers,workspace);
        String JSONString = JSON.serialize(newTask);
        JSONString = '{"data":'+JSONString+'}';
        HttpResponse res;
        string base64Key = createAuthorizationHeader(apiKey);
        /**
         * API call cannot be made while test class in running.
         * so setting the expected response on which code would run
         */
        if(Test.isRunningTest()){
        	res = new HttpResponse();
        	if(apiKey == 'error'){
        		res.setStatusCode(300);
        	}
        	else{
        		res.setStatusCode(201);
        	}
        	res.setBody('{"data":{"id":1283822080991,"created_at":"2012-07-18T18:15:51.390Z","modified_at":"2012-07-18T18:15:51.390Z",'+
        				+ '"name":"test sfdc","notes":"Test SFDC","completed":false,"assignee_status":"inbox","completed_at":null,'+
        				+ '"due_on":"2012-07-18","workspace":{"id":1274789517063,"name":"Your Companys Name"},"followers":[],'+
        				+ '"projects":[],"tags":[],"assignee":{"id":1274789517058,"name":"swati gour"}}}');
        }
        else{
        	res = sendHttp(asanaEndPoint+'/tasks','POST',JSONString  ,'Basic '+base64Key);
        }
        return res;
    }

	/**
	 * Getting all the workspaces present of the API key so that user has the option
	 * to select any one
	 */
    public static HttpResponse getAllWorkspaces(string apiKey){
        HttpResponse res;
        /**
         * Handling the use case for test class execution where API call
         * cannot be done
         */
        if(Test.isRunningTest()){
        	res = new HttpResponse();
        	if(apiKey == 'error'){
        		res.setStatusCode(300);
        	}
        	else{
        		res.setStatusCode(200);
        	}
        	res.setBody('{ "data": [ { "id": 1337, "name": "My Favorite Workspace" }] }');
        }
        else{
        	res = sendHttp(asanaEndPoint+'/workspaces','GET',null,'Basic '+createAuthorizationHeader(apiKey));
        }	 
        return res;
    }
    /**
     * Getting all the users related to the API key from Asana
     */
   	public static HttpResponse getAllUsers(string apiKey){
        HttpResponse res;
        if(Test.isRunningTest()){
        	res = new HttpResponse();
        	if(apiKey == 'error'){
        		res.setStatusCode(300);
        	}
        	else{
        		res.setStatusCode(200);
        	}
        	res.setBody('{ "data": [ { "id": 1337, "name": "My Favorite Workspace" }] }');
        }
        else{
        	res = sendHttp(asanaEndPoint+'/users','GET',null,'Basic '+createAuthorizationHeader(apiKey));
        }	
        return res;
    }
    /**
     * Creating authorization header for calling asana API
     */
    private static  string createAuthorizationHeader(string apiKey){
       system.debug(EncodingUtil.base64Encode(Blob.valueof(apiKey+':')));
       return EncodingUtil.base64Encode(Blob.valueof(apiKey+':'));
    }
	
	/**
	 * Creating and sending http request with all the required parameters
	 */
    public static HttpResponse sendHttp(string endPoint,string method,string body,string authenticationHeader){
        HttpRequest request = new HttpRequest();
        request.setMethod(method);
        request.setEndPoint(endPoint);
        request.setHeader('Content-Type','Application/json');
        if(body != null){
            request.setBody(body);
        }
        request.setHeader('Authorization',authenticationHeader);
        Http http = new Http();
        HttpResponse response;
        /**
         * Handling the case when test class will be running and API request cannot be made
         */
        if(Test.isRunningTest()){
        	response = new HttpResponse();
        	response.setStatusCode(200);
        	response.setBody('{ "data": [ { "id": 1337, "name": "My Favorite Workspace" }] }');
        }
        else{
        	response = http.send(request);
        }
        return response;
    }
    
    /**
     * Wrapper class which would hold the data needed to create new task
     */
    class NewTask{
        public String assignee;
        public string assignee_status;
        public boolean completed;
        public Date due_on;
        public string name;
        public string notes;
        public String[] followers;
        public String workspace;
        
        public NewTask(String assignee,string assignee_status,boolean completed,Date due_on,
                        string name,string notes,String[] followers,String workspace){
            this.assignee = assignee;
            this.assignee_status=assignee_status;
            this.completed = completed;
            this.due_on = due_on;
            this.name = name;
            this.notes = notes;
            this.followers = followers;
            this.workspace = workspace;
       }
    }
    
}