/**
 *	AsanaRestClient class
 *
 *	@author		chetanpg59
 *	@version	1.6
 *	@since		15-July-2012
 *
 *	This is the asana client for all the REST calls.
 */
public class AsanaRestClient
{
	//the api key for the Asana toolkit
    private static String apiKey;
    
    //the Asana api endpoint
    private static final String endpoint = 'https://app.asana.com/api/1.0';
    
    /**
     *	Get API Key method
     *
     *	@param	none
     *	@return	String	the api key
     *	@throws	AsanaRestException
     *
     *	This method will return the api key from the configured custom setting.
     *	If no api key is found, the method will throw a AsanaRestException.
     */
    private static String getApiKey()
    {
        if(apiKey == null || apiKey == '')
        {
            List<Asana_Config__c> config = Asana_Config__c.getAll().values();
            if(config != null && config.size() > 0)
            {
                apiKey = config[0].API_Key__c;
            }
            else
            {
                throw new AsanaRestException('No custom setting found');
            }
        }
        return apiKey;
    }
    
    /**
     *	Generates Authentication Header
     *
     *	@param	none
     *	@return	String	the authentication header (Should be of type - Authentication : Basic <<base 64 encoded apikey + ':'>>)
     *	@throws	AsanaRestException
     *
     *	This method will return the authentication header for all the REST calls to Asana
     *	For Basic authentication, the base 64 encoded value of Api Key and ':' is used
     */
    private static String generateAuthHeader()
    {
    	String key = getApiKey();
        if(key != null && key != '')
        {
            return EncodingUtil.base64Encode(Blob.valueOf(key + ':'));
        }
        throw new AsanaRestException('Api Key not found');
    }
    
    /**
     *	Generates a GET request
     *
     *	@param	path		the endpoint for this GET request
     *	@return	HttpRequest	the HTTP request generated for this GET request
     *
     *	This method will generate a new HTTPRequest object with the specified PATH and HEADERS
     */
    private static HttpRequest generateGetRequest(String path) 
    {
        URL uri = buildUri(path);
        HttpRequest req = new HttpRequest();
        req.setHeader('Accept', 'application/json');
        req.setHeader('Authorization', 'Basic ' + generateAuthHeader());
        req.setEndpoint(uri.toExternalForm());
        req.setMethod('GET');
        return req;
    }

	/**
     *	Generates a POST request
     *
     *	@param	path		the endpoint for this POST request
     *	@return	HttpRequest	the HTTP request generated for this POST request
     *
     *	This method will generate a new HTTPRequest object with the specified PATH
     */
    private static HttpRequest generatePostRequest(String path) 
    {
        URL uri = buildUri(path);
        HttpRequest req = new HttpRequest();
        req.setHeader('Accept', 'application/json');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Basic ' + generateAuthHeader());
        req.setEndpoint(uri.toExternalForm());
        req.setMethod('POST');
        return req;
    }

	/**
     *	Generates a PUT request
     *
     *	@param	path		the endpoint for this PUT request
     *	@return	HttpRequest	the HTTP request generated for this POST request
     *
     *	This method will generate a new HTTPRequest object with the specified PATH
     */
    private static HttpRequest generatePutRequest(String path) 
    {
        URL uri = buildUri(path);
		HttpRequest req = new HttpRequest();
        req.setHeader('Accept', 'application/json');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Basic ' + generateAuthHeader());
        req.setEndpoint(uri.toExternalForm());
        req.setMethod('PUT');
        return req;
    }

	/**
     *	Generates a DELETE request
     *
     *	@param	path		the endpoint for this DELETE request
     *	@return	HttpRequest	the HTTP request generated for this DELETE request
     *
     *	This method will generate a new HTTPRequest object with the specified PATH
     */
    /* 
    private static HttpRequest generateDeleteRequest(String path) 
    {
        URL uri = buildUri(path);
        HttpRequest req = new HttpRequest();
        req.setHeader('Accept', 'application/json');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Basic ' + generateAuthHeader());
        req.setEndpoint(uri.toExternalForm());
        req.setMethod('DELETE');
        return req;
    }
    */

	/**
     *	Generates a URL
     *
     *	@param	path	the string endpoint
     *	@return	URL		the URL generated from this endpoint
     *	@throws	AsanaRestException
     *
     *	This method will generate a URL object from the string parameter
     */
    private static URL buildUri(String path) 
    {
        URL uri;
        
        try 
        {
            uri = new URL(path);
        } 
        catch (Exception e) 
        {
            throw new AsanaRestException('Invalid uri : ' + path);
        }
        return uri;
    }
	
	/**
     *	Get User by Id
     *
     *	@param	userId				the id of the user to be retrieved from Asana
     *	@return	Asana_UserEntries	the user record from Asana
     *	@throws	AsanaRestException
     *
     *	This method will retrieve the user record from Asana based on the user id passed to this method.
     *
     *	For more details - http://developer.asana.com/documentation/#users
     */    
    public static Asana_UserEntries getUserById(String userId)
    {
        if(userId != null && userId != '')
        {
            try
            {
                String path = endpoint + '/users/' + userId;
                HttpRequest request = generateGetRequest(path);
                HttpResponse response;
                if(!Test.isRunningTest())
                {
                    response = (new Http()).send(request);
                }
                else
                {
                	response = new HttpResponse();
                	response.setBody(Asana_UtilityMethods.getUserJSONString());
                }
                Asana_UserResponseWrapper.Asana_SingleUserResponse wrap = (Asana_UserResponseWrapper.Asana_SingleUserResponse)JSON.deserialize(response.getBody(),Asana_UserResponseWrapper.Asana_SingleUserResponse.class);
                return wrap.data;
            }
            catch(Exception e)
            {
                throw new AsanaRestException(e.getMessage());
            }
        }
        else
        {
            throw new AsanaRestException('In method getUserById, userId passed was either blank or null');
        }
    }
    
    /**
     *	Get My User
     *
     *	@param	none
     *	@return	Asana_UserEntries	the user record from Asana
     *	@throws	AsanaRestException
     *
     *	This method will retrieve the user record from Asana based on the api key corresponding to the user
     *
     *	For more details - http://developer.asana.com/documentation/#users
     */
    public static Asana_UserEntries getMyUser()
    {
        try
        {
            String path = endpoint + '/users/me';
            HttpRequest request = generateGetRequest(path);
            HttpResponse response;
            if(!Test.isRunningTest())
            {
                response = (new Http()).send(request);
            }
            else
            {
            	response = new HttpResponse();
            	response.setBody(Asana_UtilityMethods.getUserJSONString());
            }
            Asana_UserResponseWrapper.Asana_SingleUserResponse wrap = (Asana_UserResponseWrapper.Asana_SingleUserResponse)JSON.deserialize(response.getBody(),Asana_UserResponseWrapper.Asana_SingleUserResponse.class);
            return wrap.data;
        }
        catch(Exception e)
        {
            throw new AsanaRestException(e.getMessage());
        }
    }

	/**
     *	Get All Users
     *
     *	@param	none
     *	@return	List<Asana_UserEntries>	the user records from Asana
     *	@throws	AsanaRestException
     *
     *	This method will retrieve all the user records from Asana
     *
     *	For more details - http://developer.asana.com/documentation/#users
     */
    public static List<Asana_UserEntries> getAllUsers()
    {
        try
        {
            String path = endpoint + '/users';
            HttpRequest request = generateGetRequest(path);
            HttpResponse response;
            if(!Test.isRunningTest())
            {
                response = (new Http()).send(request);
            }
            else
            {
            	response = new HttpResponse();
            	response.setBody(Asana_UtilityMethods.getUsersJSONString());
            	System.debug('***' + response.getBody());
            }
            Asana_UserResponseWrapper wrap = (Asana_UserResponseWrapper)JSON.deserialize(response.getBody(),Asana_UserResponseWrapper.class);
            return wrap.data;
        }
        catch(Exception e)
        {
            throw new AsanaRestException(e.getMessage());
        }
    }
    
    /**
     *	Get User by Id
     *
     *	@param	workspaceId				the id of the workspace from which the users needs to be retrieved
     *	@return	List<Asana_UserEntries>	the user records from Asana
     *	@throws	AsanaRestException
     *
     *	This method will retrieve the user records from Asana mapped to the workspaceid passed in the method
     *
     *	For more details - http://developer.asana.com/documentation/#users
     */
    public static List<Asana_UserEntries> getUsersByWorkspace(String workspaceId)
    {
        if(workspaceId != null && workspaceId != '')
        {
            try
            {
                String path = endpoint + '/workspaces/' + workspaceId + '/users';
                HttpRequest request = generateGetRequest(path);
                HttpResponse response;
                if(!Test.isRunningTest())
                {
                    response = (new Http()).send(request);
                }
                else
	            {
	            	response = new HttpResponse();
	            	response.setBody(Asana_UtilityMethods.getUsersJSONString());
	            }
                Asana_UserResponseWrapper wrap = (Asana_UserResponseWrapper)JSON.deserialize(response.getBody(),Asana_UserResponseWrapper.class);
                return wrap.data;
            }
            catch(Exception e)
            {
                throw new AsanaRestException(e.getMessage());
            }
        }
        else
        {
            throw new AsanaRestException('In method getUsersByWorkspace, workspaceId passed was either blank or null');
        }
    }
    
    /**
     *	Create Task
     *
     *	@param	task				the task to be created
     *	@return	Asana_TaskEntries	the task record returned from Asana on creation
     *	@throws	AsanaRestException
     *
     *	This method will create a new task in Asana
     *
     *	For more details - http://developer.asana.com/documentation/#tasks
     */
    public static Asana_TaskEntries createTask(Asana_TaskEntries task)
    {
    	if(task != null)
        {
            try
            {
                String path = endpoint + '/tasks';
                
                HttpRequest request = generatePostRequest(path);
                request.setBody(task.getTaskJSONString());
                
                HttpResponse response;
                if(!Test.isRunningTest())
                {
                    response = (new Http()).send(request);
                }
                else
	            {
	            	response = new HttpResponse();
	            	response.setBody(Asana_UtilityMethods.getTaskJSONString());
	            }
                Asana_TaskResponseWrapper.Asana_SingleTaskResponse wrap = (Asana_TaskResponseWrapper.Asana_SingleTaskResponse)JSON.deserialize(response.getBody(),Asana_TaskResponseWrapper.Asana_SingleTaskResponse.class);
                return wrap.data;
            }
            catch(Exception e)
            {
                throw new AsanaRestException(e.getMessage());
            }
        }
        else
        {
            throw new AsanaRestException('In method createTask, the task to be created cannot be blank or null');
        }
        return null;
    }
    
    /**
     *	Create Task in Workspace
     *
     *	@param	task				the task to be created
     *	@param	workspaceId			the workspace in which the task is to be created
     *	@return	Asana_TaskEntries	the task record returned from Asana on creation
     *	@throws	AsanaRestException
     *
     *	This method will create a new task in Asana in the specified workspace
     *
     *	For more details - http://developer.asana.com/documentation/#tasks
     */
    public static Asana_TaskEntries createTaskInWorkspace(Asana_TaskEntries task, String workspaceId)
    {
        if(task != null)
        {
        	if(workspaceId == null || workspaceId == '')
        	{
        		throw new AsanaRestException('In method createTaskInWorkspace, the workspace id cannot be blank or null');
        	}
        	
            try
            {
                String path = endpoint + '/workspaces/' + workspaceId + '/tasks';
                
                HttpRequest request = generatePostRequest(path);
                request.setBody(task.getTaskJSONString());
                
                HttpResponse response;
                if(!Test.isRunningTest())
                {
                    response = (new Http()).send(request);
                }
                else
	            {
	            	response = new HttpResponse();
	            	response.setBody(Asana_UtilityMethods.getTaskJSONString());
	            }
                Asana_TaskResponseWrapper.Asana_SingleTaskResponse wrap = (Asana_TaskResponseWrapper.Asana_SingleTaskResponse)JSON.deserialize(response.getBody(),Asana_TaskResponseWrapper.Asana_SingleTaskResponse.class);
                return wrap.data;
            }
            catch(Exception e)
            {
                throw new AsanaRestException(e.getMessage());
            }
        }
        else
        {
            throw new AsanaRestException('In method createTaskInWorkspace, the task to be created cannot be blank or null');
        }
        return null;
    }
    
    /**
     *	Get Task by Id
     *
     *	@param	taskId				the task to be retrieved
     *	@return	Asana_TaskEntries	the task record retrieved from Asana
     *	@throws	AsanaRestException
     *
     *	This method will retrieve the task record from Asana based on the taskId passed to the method
     *
     *	For more details - http://developer.asana.com/documentation/#tasks
     */
    public static Asana_TaskEntries getTaskById(String taskId)
    {
        if(taskId != null && taskId != '')
        {
            try
            {
                String path = endpoint + '/tasks/' + taskId;
                HttpRequest request = generateGetRequest(path);
                HttpResponse response;
                if(!Test.isRunningTest())
                {
                    response = (new Http()).send(request);
                }
                else
	            {
	            	response = new HttpResponse();
	            	response.setBody(Asana_UtilityMethods.getTaskJSONString());
	            }
                Asana_TaskResponseWrapper.Asana_SingleTaskResponse wrap = (Asana_TaskResponseWrapper.Asana_SingleTaskResponse)JSON.deserialize(response.getBody(),Asana_TaskResponseWrapper.Asana_SingleTaskResponse.class);
                return wrap.data;
            }
            catch(Exception e)
            {
                throw new AsanaRestException(e.getMessage());
            }
        }
        else
        {
            throw new AsanaRestException('In method getTaskById, taskId passed was either blank or null');
        }
    }
    
    /**
     *	Update Task
     *
     *	@param	task				the task to be updated
     *	@return	Asana_TaskEntries	the updated task record returned from Asana
     *	@throws	AsanaRestException
     *
     *	This method will update the task in Asana
     *
     *	For more details - http://developer.asana.com/documentation/#tasks
     */
    public static Asana_TaskEntries updateTask(Asana_TaskEntries task)
    {
        if(task != null && task.id != null)
        {
            try
            {
                String path = endpoint + '/tasks/' + task.id;
                
                HttpRequest request = generatePutRequest(path);
                request.setBody(task.getTaskJSONString());
                
                HttpResponse response;
                if(!Test.isRunningTest())
                {
                    response = (new Http()).send(request);
                }
                else
	            {
	            	response = new HttpResponse();
	            	response.setBody(Asana_UtilityMethods.getTaskJSONString());
	            }
                Asana_TaskResponseWrapper.Asana_SingleTaskResponse wrap = (Asana_TaskResponseWrapper.Asana_SingleTaskResponse)JSON.deserialize(response.getBody(),Asana_TaskResponseWrapper.Asana_SingleTaskResponse.class);
                return wrap.data;
            }
            catch(Exception e)
            {
                throw new AsanaRestException(e.getMessage());
            }
        }
        else
        {
            throw new AsanaRestException('In method updateTask, the task or the task id cannot be blank or null');
        }
        return null;
    }
    
    /**
     *	Get All Tasks
     *
     *	@param	none
     *	@return	List<Asana_TaskEntries>	the task records retrieved from Asana
     *	@throws	AsanaRestException
     *
     *	This method will retrieve all the task records from Asana
     *
     *	For more details - http://developer.asana.com/documentation/#tasks
     */
    public static List<Asana_TaskEntries> getAllTasks()
    {
    	/*
        try
        {
            String path = endpoint + '/tasks';
            HttpRequest request = generateGetRequest(path);
            HttpResponse response;
            if(!Test.isRunningTest())
            {
                response = (new Http()).send(request);
            }
            else
            {
            	response = new HttpResponse();
            	response.setBody(Asana_UtilityMethods.getTasksJSONString());
            }
            Asana_TaskResponseWrapper wrap = (Asana_TaskResponseWrapper)JSON.deserialize(response.getBody(),Asana_TaskResponseWrapper.class);
            return wrap.data;
        }
        catch(Exception e)
        {
            throw new AsanaRestException('Something went wrong in the getAllTasks method. Please try again.', e);
        }
        */
        return null;
    }
    
    /**
     *	Get Tasks on Project
     *
     *	@param	projectId				the project id on which the tasks are to be retrieved
     *	@return	List<Asana_TaskEntries>	the task records retrieved from Asana
     *	@throws	AsanaRestException
     *
     *	This method will retrieve all the tasks from Asana based on the projectId passed to the method
     *
     *	For more details - http://developer.asana.com/documentation/#tasks
     */
    public static List<Asana_TaskEntries> getTasksByProject(String projectId)
    {
        if(projectId != null && projectId != '')
        {
            try
            {
                String path = endpoint + '/projects/' + projectId + '/tasks';
                HttpRequest request = generateGetRequest(path);
                HttpResponse response;
                if(!Test.isRunningTest())
                {
                    response = (new Http()).send(request);
                }
                else
	            {
	            	response = new HttpResponse();
	            	response.setBody(Asana_UtilityMethods.getTasksJSONString());
	            }
                Asana_TaskResponseWrapper wrap = (Asana_TaskResponseWrapper)JSON.deserialize(response.getBody(),Asana_TaskResponseWrapper.class);
                return wrap.data;
            }
            catch(Exception e)
            {
                throw new AsanaRestException(e.getMessage());
            }
        }
        else
        {
            throw new AsanaRestException('In method getTaskByProject, projectId passed was either blank or null');
        }
    }
    
    /**
     *	Get Tasks in Workspace
     *
     *	@param	workspaceId				the workspace id from which the tasks are to be retrieved
     *	@param	assigneeId				the user to whom the task is assigned
     *	@return	List<Asana_TaskEntries>	the task records retrieved from Asana
     *	@throws	AsanaRestException
     *
     *	This method will retrieve all the tasks from Asana based on the workspace and assignee passed to the method
     *
     *	For more details - http://developer.asana.com/documentation/#tasks
     */
    public static List<Asana_TaskEntries> getTasksByWorkspace(String workspaceId, String assigneeId)
    {
        if(workspaceId != null && workspaceId != '' && assigneeId != null && assigneeId != '')
        {
            try
            {
                String path = endpoint + '/workspaces/' + workspaceId + '/tasks?assignee=' + assigneeId;
                HttpRequest request = generateGetRequest(path);
                HttpResponse response;
                if(!Test.isRunningTest())
                {
                    response = (new Http()).send(request);
                }
                else
	            {
	            	response = new HttpResponse();
	            	response.setBody(Asana_UtilityMethods.getTasksJSONString());
	            }
                Asana_TaskResponseWrapper wrap = (Asana_TaskResponseWrapper)JSON.deserialize(response.getBody(),Asana_TaskResponseWrapper.class);
                return wrap.data;
            }
            catch(Exception e)
            {
                throw new AsanaRestException(e.getMessage());
            }
        }
        else
        {
            throw new AsanaRestException('In method getTaskByWorkspace, workspaceId or assigneeId passed was either blank or null');
        }
    }
    
    /**
     *	Get Stories on Task
     *
     *	@param	taskId						the task id from which the stories are to be retrieved
     *	@return	List<Asana_StoryEntries>	the story records retrieved from Asana
     *	@throws	AsanaRestException
     *
     *	This method will retrieve all the stories from Asana based on the taskId passed to the method
     *
     *	For more details - http://developer.asana.com/documentation/#stories
     */
    public static List<Asana_StoryEntries> getStoriesOnTask(String taskId)
    {
        if(taskId != null && taskId != '')
        {
            try
            {
                String path = endpoint + '/tasks/' + taskId + '/stories';
                HttpRequest request = generateGetRequest(path);
                HttpResponse response;
                if(!Test.isRunningTest())
                {
                    response = (new Http()).send(request);
                }
                else
	            {
	            	response = new HttpResponse();
	            	response.setBody(Asana_UtilityMethods.getStoriesJSONString());
	            }
                Asana_StoryResponseWrapper wrap = (Asana_StoryResponseWrapper)JSON.deserialize(response.getBody(),Asana_StoryResponseWrapper.class);
                return wrap.data;
            }
            catch(Exception e)
            {
                throw new AsanaRestException(e.getMessage());
            }
        }
        else
        {
            throw new AsanaRestException('In method getStoryOnTask, taskId passed was either blank or null');
        }
    }
    
    /**
     *	Post Stories on Task
     *
     *	@param	story				the story to be posted
     *	@param	taskId				the task on which the story needs to be posted
     *	@return	Asana_StoryEntries	the story created on the task
     *	@throws	AsanaRestException
     *
     *	This method will post a story in Asana based on the taskId passed to the method
     *
     *	For more details - http://developer.asana.com/documentation/#stories
     */
    public static Asana_StoryEntries postCommentOnTask(Asana_StoryEntries story, String taskId)
    {
        if(story != null)
        {
        	if(taskId == null || taskId == '')
        	{
        		throw new AsanaRestException('In method createTaskInWorkspace, the workspace id cannot be blank or null');
        	}
        	
            try
            {
                String path = endpoint + '/tasks/' + taskId + '/stories';
                
                HttpRequest request = generatePostRequest(path);
                request.setBody(story.getStoryJSONString());
                
                HttpResponse response;
                if(!Test.isRunningTest())
                {
                    response = (new Http()).send(request);
                }
                else
	            {
	            	response = new HttpResponse();
	            	response.setBody(Asana_UtilityMethods.getStoryJSONString());
	            }
                Asana_StoryResponseWrapper.Asana_SingleStoryResponse wrap = (Asana_StoryResponseWrapper.Asana_SingleStoryResponse)JSON.deserialize(response.getBody(),Asana_StoryResponseWrapper.Asana_SingleStoryResponse.class);
                return wrap.data;
            }
            catch(Exception e)
            {
                throw new AsanaRestException(e.getMessage());
            }
        }
        else
        {
            throw new AsanaRestException('In method postCommentOnTask, the task or the task id cannot be blank or null');
        }
        return null;
    }
    
    /**
     *	Get Tags on Task
     *
     *	@param	taskId					the task id from which the tags are to be retrieved
     *	@return	List<Asana_TagEntries>	the tag records retrieved from Asana
     *	@throws	AsanaRestException
     *
     *	This method will retrieve all the tags from Asana based on the taskId passed to the method
     *
     *	For more details - http://developer.asana.com/documentation/#tasks
     */
    public static List<Asana_TagEntries> getTagsOnTask(String taskId)
    {
        if(taskId != null && taskId != '')
        {
            try
            {
                String path = endpoint + '/tasks/' + taskId + '/stories';
                HttpRequest request = generateGetRequest(path);
                HttpResponse response;
                if(!Test.isRunningTest())
                {
                    response = (new Http()).send(request);
                }
                else
	            {
	            	response = new HttpResponse();
	            	response.setBody(Asana_UtilityMethods.getTagsJSONString());
	            }
                Asana_TagResponseWrapper wrap = (Asana_TagResponseWrapper)JSON.deserialize(response.getBody(),Asana_TagResponseWrapper.class);
                return wrap.data;
            }
            catch(Exception e)
            {
                throw new AsanaRestException(e.getMessage());
            }
        }
        else
        {
            throw new AsanaRestException('In method getTagsOnTask, taskId passed was either blank or null');
        }
    }
    
    /**
     *	Add Tag to Task
     *
     *	@param	tag					the tag to be created
     *	@param	taskId				the task on which the tag has to be created
     *	@return	Asana_TagEntries	the tag created on the task
     *	@throws	AsanaRestException
     *
     *	This method will create a tag in Asana based on the taskId passed to the method
     *
     *	For more details - http://developer.asana.com/documentation/#tasks
     */
    public static Asana_TagEntries addTagToTask(Asana_TagEntries tag, String taskId)
    {
    	if(tag != null && taskId != null && taskId != '')
        {
            try
            {
                String path = endpoint + '/tasks/' + taskId + '/addTag';
                
                HttpRequest request = generatePostRequest(path);
                
                //Asana_TagEntries tagAdd = new Asana_TagEntries();
                //tagAdd.id = tag.id;
                
                request.setBody(tag.getTagJSONString());
                
                HttpResponse response;
                if(!Test.isRunningTest())
                {
                    response = (new Http()).send(request);
                }
                else
	            {
	            	response = new HttpResponse();
	            	response.setBody(Asana_UtilityMethods.getTagJSONString());
	            }
                Asana_TagResponseWrapper.Asana_SingleTagResponse wrap = (Asana_TagResponseWrapper.Asana_SingleTagResponse)JSON.deserialize(response.getBody(),Asana_TagResponseWrapper.Asana_SingleTagResponse.class);
                return wrap.data;
            }
            catch(Exception e)
            {
                throw new AsanaRestException(e.getMessage());
            }
        }
        else
        {
            throw new AsanaRestException('In method addTagToTask, tag or taskId passed was either blank or null');
        }
        return null;
    }
    
    /**
     *	Remove Tag from Task
     *
     *	@param	tag					the tag to be removed
     *	@param	taskId				the task from which the tag needs to be removed
     *	@return	Asana_TagEntries	the tag removed from the task
     *	@throws	AsanaRestException
     *
     *	This method will remove a tag in Asana based on the taskId passed to the method
     *
     *	For more details - http://developer.asana.com/documentation/#tasks
     */
    public static Asana_TagEntries removeTagFromTask(Asana_TagEntries tag, String taskId)
    {
        if(tag != null && taskId != null && taskId != '')
        {
            try
            {
                String path = endpoint + '/tasks/' + taskId + '/removeTag';
                
                HttpRequest request = generatePostRequest(path);
                
                //Asana_TagEntries tagAdd = new Asana_TagEntries();
                //tagAdd.id = tag.id;
                
                request.setBody(tag.getTagJSONString());
                
                HttpResponse response;
                if(!Test.isRunningTest())
                {
                    response = (new Http()).send(request);
                }
                else
	            {
	            	response = new HttpResponse();
	            	response.setBody(Asana_UtilityMethods.getTagJSONString());
	            }
                Asana_TagResponseWrapper.Asana_SingleTagResponse wrap = (Asana_TagResponseWrapper.Asana_SingleTagResponse)JSON.deserialize(response.getBody(),Asana_TagResponseWrapper.Asana_SingleTagResponse.class);
                return wrap.data;
            }
            catch(Exception e)
            {
                throw new AsanaRestException(e.getMessage());
            }
        }
        else
        {
            throw new AsanaRestException('In method removeTagFromTask, tag or taskId passed was either blank or null');
        }
        return null;
    }
    
    /**
     *	Create Project
     *
     *	@param	project					the project record to be created in Asana
     *	@return	Asana_ProjectEntries	the newly created project in Asana
     *	@throws	AsanaRestException
     *
     *	This method will create a new project in Asana
     *
     *	For more details - http://developer.asana.com/documentation/#projects
     */
    public static Asana_ProjectEntries createProject(Asana_ProjectEntries project)
    {
    	if(project != null)
        {
        	if(project.workspace == null || project.workspace.id == null || project.workspace.id == '')
        	{
        		throw new AsanaRestException('In method createProject, the workspace id cannot be blank or null');
        	}
        	
            try
            {
                String path = endpoint + '/projects';
                
                HttpRequest request = generatePostRequest(path);
                request.setBody(project.getProjectJSONString());
                
                HttpResponse response;
                if(!Test.isRunningTest())
                {
                    response = (new Http()).send(request);
                }
                else
	            {
	            	response = new HttpResponse();
	            	response.setBody(Asana_UtilityMethods.getProjectJSONString());
	            }
                Asana_ProjectResponseWrapper.Asana_SingleProjectResponse wrap = (Asana_ProjectResponseWrapper.Asana_SingleProjectResponse)JSON.deserialize(response.getBody(),Asana_ProjectResponseWrapper.Asana_SingleProjectResponse.class);
                return wrap.data;
            }
            catch(Exception e)
            {
                throw new AsanaRestException(e.getMessage());
            }
        }
        else
        {
            throw new AsanaRestException('In method createProject, the project to be created cannot be blank or null');
        }
        return null;
    }
    
    /**
     *	Create Project in Workspace
     *
     *	@param	project					the project record to be created in Asana
     *	@param	workspaceId				the workspace in which the project needs to be created
     *	@return	Asana_ProjectEntries	the newly created project in Asana
     *	@throws	AsanaRestException
     *
     *	This method will create a new project in Asana in the specified workspace
     *
     *	For more details - http://developer.asana.com/documentation/#projects
     */
    public static Asana_ProjectEntries createProjectInWorkspace(Asana_ProjectEntries project, String workspaceId)
    {
    	if(project != null)
        {
        	if(workspaceId == null || workspaceId == '')
        	{
        		throw new AsanaRestException('In method createProjectInWorkspace, the workspace id cannot be blank or null');
        	}
        	
            try
            {
                String path = endpoint + '/workspaces/' + workspaceId +  '/projects';
                
                HttpRequest request = generatePostRequest(path);
                request.setBody(project.getProjectJSONString());
                
                HttpResponse response;
                if(!Test.isRunningTest())
                {
                    response = (new Http()).send(request);
                }
                else
	            {
	            	response = new HttpResponse();
	            	response.setBody(Asana_UtilityMethods.getProjectJSONString());
	            }
                Asana_ProjectResponseWrapper.Asana_SingleProjectResponse wrap = (Asana_ProjectResponseWrapper.Asana_SingleProjectResponse)JSON.deserialize(response.getBody(),Asana_ProjectResponseWrapper.Asana_SingleProjectResponse.class);
                return wrap.data;
            }
            catch(Exception e)
            {
                throw new AsanaRestException(e.getMessage());
            }
        }
        else
        {
            throw new AsanaRestException('In method createProjectInWorkspace, the project to be created cannot be blank or null');
        }
        return null;
    }
    
    /**
     *	Get Project by Id
     *
     *	@param	projectid				the id of the project to be retrieved from Asana
     *	@return	Asana_ProjectEntries	the retrieved project from Asana
     *	@throws	AsanaRestException
     *
     *	This method will retrieve a project from Asana based on the project id passed to the method
     *
     *	For more details - http://developer.asana.com/documentation/#projects
     */
    public static Asana_ProjectEntries getProjectById(String projectId)
    {
        if(projectId != null && projectId != '')
        {
            try
            {
                String path = endpoint + '/projects/' + projectId;
                HttpRequest request = generateGetRequest(path);
                HttpResponse response;
                if(!Test.isRunningTest())
                {
                    response = (new Http()).send(request);
                }
                else
	            {
	            	response = new HttpResponse();
	            	response.setBody(Asana_UtilityMethods.getProjectJSONString());
	            }
                Asana_ProjectResponseWrapper.Asana_SingleProjectResponse wrap = (Asana_ProjectResponseWrapper.Asana_SingleProjectResponse)JSON.deserialize(response.getBody(),Asana_ProjectResponseWrapper.Asana_SingleProjectResponse.class);
                return wrap.data;
            }
            catch(Exception e)
            {
                throw new AsanaRestException(e.getMessage());
            }
        }
        else
        {
            throw new AsanaRestException('In method getTagsOnTask, taskId passed was either blank or null');
        }
    }
    
    /**
     *	Update a project
     *
     *	@param	project					the project to be udpated in Asana
     *	@return	Asana_ProjectEntries	the updated project from Asana
     *	@throws	AsanaRestException
     *
     *	This method will update a project in Asana
     *
     *	For more details - http://developer.asana.com/documentation/#projects
     */
    public static Asana_ProjectEntries updateProject(Asana_ProjectEntries project)
    {
        if(project != null && (project.id != null || project.id != ''))
        {
            try
            {
                String path = endpoint + '/projects/' + project.id;
                
                HttpRequest request = generatePutRequest(path);
                request.setBody(project.getProjectJSONString());
                
                HttpResponse response;
                if(!Test.isRunningTest())
                {
                    response = (new Http()).send(request);
                }
                else
	            {
	            	response = new HttpResponse();
	            	response.setBody(Asana_UtilityMethods.getProjectJSONString());
	            }
                Asana_ProjectResponseWrapper.Asana_SingleProjectResponse wrap = (Asana_ProjectResponseWrapper.Asana_SingleProjectResponse)JSON.deserialize(response.getBody(),Asana_ProjectResponseWrapper.Asana_SingleProjectResponse.class);
                return wrap.data;
            }
            catch(Exception e)
            {
                throw new AsanaRestException(e.getMessage());
            }
        }
        else
        {
            throw new AsanaRestException('In method updateProject, the project or the project id cannot be blank or null');
        }
        return null;
    }
    
    /**
     *	Get Task on a Project
     *
     *	@param	projectId				the project id on which the tasks are to be retrieved
     *	@return	Asana_TaskEntries		the retrieved Task from Asana
     *	@throws	AsanaRestException
     *
     *	This method will retrieve a task from Asana based on the project id passed to the method
     *
     *	For more details - http://developer.asana.com/documentation/#tasks
     */
    public static List<Asana_TaskEntries> getTasksOnProject(String projectId)
    {
        if(projectId != null && projectId != '')
        {
            try
            {
                String path = endpoint + '/projects/' + projectId + '/tasks';
                HttpRequest request = generateGetRequest(path);
                HttpResponse response;
                if(!Test.isRunningTest())
                {
                    response = (new Http()).send(request);
                }
                else
	            {
	            	response = new HttpResponse();
	            	response.setBody(Asana_UtilityMethods.getTasksJSONString());
	            }
                Asana_TaskResponseWrapper wrap = (Asana_TaskResponseWrapper)JSON.deserialize(response.getBody(),Asana_TaskResponseWrapper.class);
                return wrap.data;
            }
            catch(Exception e)
            {
                throw new AsanaRestException(e.getMessage());
            }
        }
        else
        {
            throw new AsanaRestException('In method getTasksOnProject, projectId passed was either blank or null');
        }
    }
    
    /**
     *	Get Projects in a workspace
     *
     *	@param	workspace					the workspace id from which the projects are to be retrieved
     *	@return	List<Asana_ProjectEntries>	the retrieved Projects from Asana
     *	@throws	AsanaRestException
     *
     *	This method will retrieve projects from Asana based on the workspace id passed to the method
     *
     *	For more details - http://developer.asana.com/documentation/#projects
     */
    public static List<Asana_ProjectEntries> getProjectsInWorkspace(String workspaceId)
    {
        if(workspaceId != null && workspaceId != '')
        {
            try
            {
                String path = endpoint + '/workspaces/' + workspaceId + '/projects';
                HttpRequest request = generateGetRequest(path);
                HttpResponse response;
                if(!Test.isRunningTest())
                {
                    response = (new Http()).send(request);
                }
                else
	            {
	            	response = new HttpResponse();
	            	response.setBody(Asana_UtilityMethods.getProjectsJSONString());
	            }
                Asana_ProjectResponseWrapper wrap = (Asana_ProjectResponseWrapper)JSON.deserialize(response.getBody(),Asana_ProjectResponseWrapper.class);
                return wrap.data;
            }
            catch(Exception e)
            {
                throw new AsanaRestException(e.getMessage());
            }
        }
        else
        {
            throw new AsanaRestException('In method getProjectsInWorkspace, workspaceId passed was either blank or null');
        }
    }
    
    /**
     *	Get All Projects
     *
     *	@param	none
     *	@return	List<Asana_ProjectEntries>	the retrieved Projects from Asana
     *	@throws	AsanaRestException
     *
     *	This method will retrieve all projects from Asana
     *
     *	For more details - http://developer.asana.com/documentation/#projects
     */
    public static List<Asana_ProjectEntries> getAllProjects()
    {
        try
        {
            String path = endpoint + '/projects';
            HttpRequest request = generateGetRequest(path);
            HttpResponse response;
            if(!Test.isRunningTest())
            {
                response = (new Http()).send(request);
            }
            else
            {
            	response = new HttpResponse();
            	response.setBody(Asana_UtilityMethods.getProjectsJSONString());
            }
            Asana_ProjectResponseWrapper wrap = (Asana_ProjectResponseWrapper)JSON.deserialize(response.getBody(),Asana_ProjectResponseWrapper.class);
            return wrap.data;
        }
        catch(Exception e)
        {
            throw new AsanaRestException(e.getMessage());
        }
    }
    
    /**
     *	Create Tag in Workspace
     *
     *	@param	tag					the tag to be added to the workspace
     *	@param	workspaceId			the workspace to which this tag needs to be added							
     *	@return	Asana_TagEntries	the tag added to the workspace
     *	@throws	AsanaRestException
     *
     *	This method will add a new tag to a workspace in Asana
     *
     *	For more details - http://developer.asana.com/documentation/#tags
     */
    public static Asana_TagEntries createTagInWorkspace(Asana_TagEntries tag, String workspaceId)
    {
        if(tag != null)
        {
        	if(workspaceId == null || workspaceId == '')
        	{
        		throw new AsanaRestException('In method createTagInWorkspace, the workspace id cannot be blank or null');
        	}
        	
            try
            {
                String path = endpoint + '/workspaces/' + workspaceId +  '/tags';
                
                HttpRequest request = generatePostRequest(path);
                request.setBody(tag.getTagJSONString());
                
                HttpResponse response;
                if(!Test.isRunningTest())
                {
                    response = (new Http()).send(request);
                }
                else
	            {
	            	response = new HttpResponse();
	            	response.setBody(Asana_UtilityMethods.getTagJSONString());
	            }
                Asana_TagResponseWrapper.Asana_SingleTagResponse wrap = (Asana_TagResponseWrapper.Asana_SingleTagResponse)JSON.deserialize(response.getBody(),Asana_TagResponseWrapper.Asana_SingleTagResponse.class);
                return wrap.data;
            }
            catch(Exception e)
            {
                throw new AsanaRestException(e.getMessage());
            }
        }
        else
        {
            throw new AsanaRestException('In method createTagInWorkspace, the tag to be created cannot be blank or null');
        }
        return null;
    }
    
    /**
     *	Create Tag 
     *
     *	@param	tag					the tag to be added in Asana
     *	@return	Asana_TagEntries	the tag added in Asana
     *	@throws	AsanaRestException
     *
     *	This method will add a new tag in Asana
     *
     *	For more details - http://developer.asana.com/documentation/#tags
     */
    public static Asana_TagEntries createTag(Asana_TagEntries tag)
    {
        if(tag != null)
        {
            try
            {
                String path = endpoint + '/tags';
                
                HttpRequest request = generatePostRequest(path);
                request.setBody(tag.getTagJSONString());
                
                HttpResponse response;
                if(!Test.isRunningTest())
                {
                    response = (new Http()).send(request);
                }
                else
	            {
	            	response = new HttpResponse();
	            	response.setBody(Asana_UtilityMethods.getTagJSONString());
	            }
                Asana_TagResponseWrapper.Asana_SingleTagResponse wrap = (Asana_TagResponseWrapper.Asana_SingleTagResponse)JSON.deserialize(response.getBody(),Asana_TagResponseWrapper.Asana_SingleTagResponse.class);
                return wrap.data;
            }
            catch(Exception e)
            {
                throw new AsanaRestException(e.getMessage());
            }
        }
        else
        {
            throw new AsanaRestException('In method createNewTag, the tag to be created cannot be blank or null');
        }
        return null;
    }
    
    /**
     *	Get Tag by Id 
     *
     *	@param	tagId				the tag id to be retrieved from Asana
     *	@return	Asana_TagEntries	the tag retrieved from Asana
     *	@throws	AsanaRestException
     *
     *	This method will retrieve tag from Asana based on the tag id passed to the method
     *
     *	For more details - http://developer.asana.com/documentation/#tags
     */
    public static Asana_TagEntries getTagById(String tagId)
    {
        if(tagId != null && tagId != '')
        {
            try
            {
                String path = endpoint + '/tags/' + tagId;
                HttpRequest request = generateGetRequest(path);
                HttpResponse response;
                if(!Test.isRunningTest())
                {
                    response = (new Http()).send(request);
                }
                else
	            {
	            	response = new HttpResponse();
	            	response.setBody(Asana_UtilityMethods.getTagJSONString());
	            }
                Asana_TagResponseWrapper.Asana_SingleTagResponse wrap = (Asana_TagResponseWrapper.Asana_SingleTagResponse)JSON.deserialize(response.getBody(),Asana_TagResponseWrapper.Asana_SingleTagResponse.class);
                return wrap.data;
            }
            catch(Exception e)
            {
                throw new AsanaRestException(e.getMessage());
            }
        }
        else
        {
            throw new AsanaRestException('In method getTagById, tagId passed was either blank or null');
        }
    }
    
    /**
     *	Update Tag 
     *
     *	@param	tag					the tag to be updated in Asana
     *	@return	Asana_TagEntries	the updated tag from Asana
     *	@throws	AsanaRestException
     *
     *	This method will update tag in Asana
     *
     *	For more details - http://developer.asana.com/documentation/#tags
     */
    public static Asana_TagEntries updateTag(Asana_TagEntries tag)
    {
        if(tag != null && tag.id != null && tag.id != '')
        {
            try
            {
                String path = endpoint + '/tags/' + tag.id;
                
                HttpRequest request = generatePutRequest(path);
                request.setBody(tag.getTagJSONString());
                
                HttpResponse response;
                if(!Test.isRunningTest())
                {
                    response = (new Http()).send(request);
                }
                else
	            {
	            	response = new HttpResponse();
	            	response.setBody(Asana_UtilityMethods.getTagJSONString());
	            	System.debug('***' + response.getBody());
	            }
                Asana_TagResponseWrapper.Asana_SingleTagResponse wrap = (Asana_TagResponseWrapper.Asana_SingleTagResponse)JSON.deserialize(response.getBody(),Asana_TagResponseWrapper.Asana_SingleTagResponse.class);
	            return wrap.data;
            }
            catch(Exception e)
            {
                throw new AsanaRestException(e.getMessage());
            }
        }
        else
        {
            throw new AsanaRestException('In method updateTag, the tag or tag id cannot be blank or null');
        }
        return null;
    }
    
    /**
     *	Get Tasks by tag Id 
     *
     *	@param	tagId					the tag id to be used to retrieve tasks from Asana
     *	@return	List<Asana_TaskEntries>	the tasks retrieved from Asana
     *	@throws	AsanaRestException
     *
     *	This method will retrieve tasks from Asana based on the tag id passed to the method
     *
     *	For more details - http://developer.asana.com/documentation/#tags
     */
    public static List<Asana_TaskEntries> getTasksByTag(String tagId)
    {
        if(tagId != null && tagId != '')
        {
            try
            {
                String path = endpoint + '/tags/' + tagId + '/tasks';
                HttpRequest request = generateGetRequest(path);
                HttpResponse response;
                if(!Test.isRunningTest())
                {
                    response = (new Http()).send(request);
                }
                else
	            {
	            	response = new HttpResponse();
	            	response.setBody(Asana_UtilityMethods.getTasksJSONString());
	            }
                Asana_TaskResponseWrapper wrap = (Asana_TaskResponseWrapper)JSON.deserialize(response.getBody(),Asana_TaskResponseWrapper.class);
                return wrap.data;
            }
            catch(Exception e)
            {
                throw new AsanaRestException(e.getMessage());
            }
        }
        else
        {
            throw new AsanaRestException('In method getTasksByTag, tagId passed was either blank or null');
        }
    }
    
    /**
     *	Get All Tags 
     *
     *	@param	none
     *	@return	List<Asana_TagEntries>	the tags retrieved from Asana
     *	@throws	AsanaRestException
     *
     *	This method will retrieve all tags from Asana
     *
     *	For more details - http://developer.asana.com/documentation/#tags
     */
    public static List<Asana_TagEntries> getAllTags()
    {
        try
        {
            String path = endpoint + '/tags';
            HttpRequest request = generateGetRequest(path);
            HttpResponse response;
            if(!Test.isRunningTest())
            {
                response = (new Http()).send(request);
            }
            else
            {
            	response = new HttpResponse();
            	response.setBody(Asana_UtilityMethods.getTagsJSONString());
            }
            Asana_TagResponseWrapper wrap = (Asana_TagResponseWrapper)JSON.deserialize(response.getBody(),Asana_TagResponseWrapper.class);
            return wrap.data;
        }
        catch(Exception e)
        {
            throw new AsanaRestException(e.getMessage());
        }
    }
    
    /**
     *	Get tags by workspace Id 
     *
     *	@param	workspaceId				the workspace id to be used to retrieve tags from Asana
     *	@return	List<Asana_TagEntries>	the tags retrieved from Asana
     *	@throws	AsanaRestException
     *
     *	This method will retrieve tags from Asana based on the workspace id passed to the method
     *
     *	For more details - http://developer.asana.com/documentation/#tags
     */
    public static List<Asana_TagEntries> getTagsByWorkspace(String workspaceId)
    {
        if(workspaceId != null && workspaceId != '')
        {
            try
            {
                String path = endpoint + '/workspaces/' + workspaceId + '/tags';
                HttpRequest request = generateGetRequest(path);
                HttpResponse response;
                if(!Test.isRunningTest())
                {
                    response = (new Http()).send(request);
                }
                else
	            {
	            	response = new HttpResponse();
	            	response.setBody(Asana_UtilityMethods.getTagsJSONString());
	            }
                Asana_TagResponseWrapper wrap = (Asana_TagResponseWrapper)JSON.deserialize(response.getBody(),Asana_TagResponseWrapper.class);
                return wrap.data;
            }
            catch(Exception e)
            {
                throw new AsanaRestException(e.getMessage());
            }
        }
        else
        {
            throw new AsanaRestException('In method getTagsByWorkspace, workspaceId passed was either blank or null');
        }
    }
    
    /**
     *	Get comments on Task 
     *
     *	@param	taskId						the task id on which the comments are to be retrieved from Asana
     *	@return	List<Asana_StoryEntries>	the comments retrieved from Asana
     *	@throws	AsanaRestException
     *
     *	This method will retrieve comments from Asana based on the task id passed to the method
     *
     *	For more details - http://developer.asana.com/documentation/#stories
     */
    public static List<Asana_StoryEntries> getCommentsOnTask(String taskId)
    {
        if(taskId != null && taskId != '')
        {
            try
            {
                String path = endpoint + '/tasks/' + taskId + '/stories';
                HttpRequest request = generateGetRequest(path);
                HttpResponse response;
                if(!Test.isRunningTest())
                {
                    response = (new Http()).send(request);
                }
                else
	            {
	            	response = new HttpResponse();
	            	response.setBody(Asana_UtilityMethods.getStoriesJSONString());
	            }
                Asana_StoryResponseWrapper wrap = (Asana_StoryResponseWrapper)JSON.deserialize(response.getBody(),Asana_StoryResponseWrapper.class);
                return wrap.data;
            }
            catch(Exception e)
            {
                throw new AsanaRestException(e.getMessage());
            }
        }
        else
        {
            throw new AsanaRestException('In method getCommentsOnTask, taskId passed was either blank or null');
        }
    }
    
    /**
     *	Get comments on project 
     *
     *	@param	project						the project id on which the comments are to be retrieved from Asana
     *	@return	List<Asana_StoryEntries>	the comments retrieved from Asana
     *	@throws	AsanaRestException
     *
     *	This method will retrieve comments from Asana based on the project id passed to the method
     *
     *	For more details - http://developer.asana.com/documentation/#stories
     */
    public static List<Asana_StoryEntries> getCommentsOnProject(String projectId)
    {
        if(projectId != null && projectId != '')
        {
            try
            {
                String path = endpoint + '/projects/' + projectId + '/stories';
                HttpRequest request = generateGetRequest(path);
                HttpResponse response;
                if(!Test.isRunningTest())
                {
                    response = (new Http()).send(request);
                }
                else
	            {
	            	response = new HttpResponse();
	            	response.setBody(Asana_UtilityMethods.getStoriesJSONString());
	            }
                Asana_StoryResponseWrapper wrap = (Asana_StoryResponseWrapper)JSON.deserialize(response.getBody(),Asana_StoryResponseWrapper.class);
                return wrap.data;
            }
            catch(Exception e)
            {
                throw new AsanaRestException(e.getMessage());
            }
        }
        else
        {
            throw new AsanaRestException('In method getCommentsOnProject, projectId passed was either blank or null');
        }
    }
    
    /**
     *	Get story by Id
     *
     *	@param	storyId				the id of the story to be retrieved from Asana
     *	@return	Asana_StoryEntries	the story from Asana
     *	@throws	AsanaRestException
     *
     *	This method will retrieve the story from Asana based on the storyId passed to the method
     *
     *	For more details - http://developer.asana.com/documentation/#stories
     */
    public static Asana_StoryEntries getStoryById(String storyId)
    {
        if(storyId != null && storyId != '')
        {
            try
            {
                String path = endpoint + '/stories/' + storyId;
                HttpRequest request = generateGetRequest(path);
                HttpResponse response;
                if(!Test.isRunningTest())
                {
                    response = (new Http()).send(request);
                }
                else
	            {
	            	response = new HttpResponse();
	            	response.setBody(Asana_UtilityMethods.getStoryJSONString());
	            }
                Asana_StoryResponseWrapper.Asana_SingleStoryResponse wrap = (Asana_StoryResponseWrapper.Asana_SingleStoryResponse)JSON.deserialize(response.getBody(),Asana_StoryResponseWrapper.Asana_SingleStoryResponse.class);
                return wrap.data;
            }
            catch(Exception e)
            {
                throw new AsanaRestException(e.getMessage());
            }
        }
        else
        {
            throw new AsanaRestException('In method getStoryById, storyId passed was either blank or null');
        }
    }
    
    /**
     *	Post a comment on project
     *
     *	@param	story				the comment to be posted
     *	@param	projectId			the project id on which the story is to be posted
     *	@return	Asana_StoryEntries	the story that was created on the project
     *	@throws	AsanaRestException
     *
     *	This method will post a comment on the project in Asana
     *
     *	For more details - http://developer.asana.com/documentation/#stories
     */
    public static Asana_StoryEntries commentOnProject(Asana_StoryEntries story, String projectId)
    {
    	if(story != null)
        {
        	if(projectId == null || projectId == '')
        	{
        		throw new AsanaRestException('In method commentOnProject, the project Id cannot be blank or null');
        	}
        	
            try
            {
                String path = endpoint + '/projects/' + projectId + '/stories';
                
                HttpRequest request = generatePostRequest(path);
                request.setBody(story.getStoryJSONString());
                
                HttpResponse response;
                if(!Test.isRunningTest())
                {
                    response = (new Http()).send(request);
                }
                else
	            {
	            	response = new HttpResponse();
	            	response.setBody(Asana_UtilityMethods.getStoryJSONString());
	            }
                Asana_StoryResponseWrapper.Asana_SingleStoryResponse wrap = (Asana_StoryResponseWrapper.Asana_SingleStoryResponse)JSON.deserialize(response.getBody(),Asana_StoryResponseWrapper.Asana_SingleStoryResponse.class);
                return wrap.data;
            }
            catch(Exception e)
            {
                throw new AsanaRestException(e.getMessage());
            }
        }
        else
        {
            throw new AsanaRestException('In method commentOnProject, the story or the project id cannot be blank or null');
        }
        return null;
    }
    
    /**
     *	Post a comment on task
     *
     *	@param	story				the comment to be posted
     *	@param	taskId				the task id on which the story is to be posted
     *	@return	Asana_StoryEntries	the story posted on the task
     *	@throws	AsanaRestException
     *
     *	This method will post a comment on the task in Asana
     *
     *	For more details - http://developer.asana.com/documentation/#stories
     */
    public static Asana_StoryEntries commentOnTask(Asana_StoryEntries story, String taskId)
    {
       if(story != null)
        {
        	if(taskId == null || taskId == '')
        	{
        		throw new AsanaRestException('In method commentOnTask, the task Id cannot be blank or null');
        	}
        	
            try
            {
                String path = endpoint + '/tasks/' + taskId + '/stories';
                
                HttpRequest request = generatePostRequest(path);
                request.setBody(story.getStoryJSONString());
                
                HttpResponse response;
                if(!Test.isRunningTest())
                {
                    response = (new Http()).send(request);
                }
                else
	            {
	            	response = new HttpResponse();
	            	response.setBody(Asana_UtilityMethods.getStoryJSONString());
	            }
                Asana_StoryResponseWrapper.Asana_SingleStoryResponse wrap = (Asana_StoryResponseWrapper.Asana_SingleStoryResponse)JSON.deserialize(response.getBody(),Asana_StoryResponseWrapper.Asana_SingleStoryResponse.class);
                return wrap.data;
            }
            catch(Exception e)
            {
                throw new AsanaRestException(e.getMessage());
            }
        }
        else
        {
            throw new AsanaRestException('In method commentOnTask, the story or the task id cannot be blank or null');
        }
        return null;
    }
    
    /**
     *	Get all workspaces
     *
     *	@param	none
     *	@return	List<Asana_WorkspaceEntries>	the workspaces from Asana
     *	@throws	AsanaRestException
     *
     *	This method will retrieve all the workspaces in Asana
     *
     *	For more details - http://developer.asana.com/documentation/#workspaces
     */
    public static List<Asana_WorkspaceEntries> getAllWorkspaces()
    {
        try
        {
            String path = endpoint + '/workspaces';
            HttpRequest request = generateGetRequest(path);
            HttpResponse response;
            if(!Test.isRunningTest())
            {
                response = (new Http()).send(request);
            }
            else
            {
            	response = new HttpResponse();
            	response.setBody(Asana_UtilityMethods.getWorkspacesJSONString());
            }
            Asana_WorkspaceResponseWrapper wrap = (Asana_WorkspaceResponseWrapper)JSON.deserialize(response.getBody(),Asana_WorkspaceResponseWrapper.class);
            return wrap.data;
        }
        catch(Exception e)
        {
            throw new AsanaRestException(e.getMessage());
        }
    }
    
    /**
     *	Update a workspace
     *
     *	@param	workspace				the workspace to be udpated in Asana
     *	@return	Asana_WorkspaceEntries	the updated workspace from Asana
     *	@throws	AsanaRestException
     *
     *	This method will update a workspace in Asana
     *
     *	For more details - http://developer.asana.com/documentation/#workspaces
     */
    public static Asana_WorkspaceEntries updateWorkspace(Asana_WorkspaceEntries workspace)
    {
        if(workspace != null && workspace.id != null && workspace.id != '')
        {
            try
            {
                String path = endpoint + '/workspaces/' + workspace.id;
                
                HttpRequest request = generatePutRequest(path);
                request.setBody(workspace.getWorkspaceJSONString());
                
                HttpResponse response;
                if(!Test.isRunningTest())
                {
                    response = (new Http()).send(request);
                }
                else
	            {
	            	response = new HttpResponse();
	            	response.setBody(Asana_UtilityMethods.getWorkspaceJSONString());
	            }
                Asana_WorkspaceResponseWrapper.Asana_SingleWorkspaceResponse wrap = (Asana_WorkspaceResponseWrapper.Asana_SingleWorkspaceResponse)JSON.deserialize(response.getBody(),Asana_WorkspaceResponseWrapper.Asana_SingleWorkspaceResponse.class);
                return wrap.data;
            }
            catch(Exception e)
            {
                throw new AsanaRestException(e.getMessage());
            }
        }
        else
        {
            throw new AsanaRestException('In method updateWorkspace, the workspace or workspace id cannot be blank or null');
        }
        return null;
    }
}