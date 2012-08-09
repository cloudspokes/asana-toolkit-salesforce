public with sharing class AsanaJsonUtility {
	public static AsanaUser getAsanaUserInstance(String jsonResponse){
		return (AsanaUser)((AsanaJsonUtility.getParser(jsonResponse)).readValueAs(AsanaUser.class));	
	}
	public static AsanaTask getAsanaTaskInstance(String jsonResponse){
		return (AsanaTask)((AsanaJsonUtility.getParser(jsonResponse)).readValueAs(AsanaTask.class));	
	}
	public static AsanaProject getAsanaProjectInstance(String jsonResponse){
		return (AsanaProject)((AsanaJsonUtility.getParser(jsonResponse)).readValueAs(AsanaProject.class));	
	}
	public static AsanaWorkspace getAsanaWorkspaceInstance(String jsonResponse){
		return (AsanaWorkspace)((AsanaJsonUtility.getParser(jsonResponse)).readValueAs(AsanaWorkspace.class));	
	}
	public static AsanaTag getAsanaTagInstance(String jsonResponse){
		return (AsanaTag)((AsanaJsonUtility.getParser(jsonResponse)).readValueAs(AsanaTag.class));	
	}
	
	public static JSONParser getParser(String jsonResponse){
		JSONParser parser 	= JSON.createParser(jsonResponse);
		if(jsonResponse.startsWith('{"data"')){
			parser.nextToken();
			parser.nextToken();
			parser.nextToken();			
		}		
		return parser;
	}
	public static List<AsanaProject> getAsanaProjectInstanceList(String jsonResponse){
		List<AsanaProject> apList = new List<AsanaProject>();
		
		if(jsonResponse.startsWith('{"data"')){
			JSONParser parser = JSON.createParser(jsonResponse);
			while (parser.nextToken() != null) {
	        	if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
	        		while (parser.nextToken() != null) {
	        			 if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
	        			 	apList.add((AsanaProject)(parser.readValueAs(AsanaProject.class)));
	        			 }
	        		}
	        	}
			}
		}
		return apList ;	
	}
	
	public static List<AsanaUser> getAsanaUserInstanceList(String jsonResponse){
		List<AsanaUser> auList = new List<AsanaUser>();
		
		if(jsonResponse.startsWith('{"data"')){
			JSONParser parser = JSON.createParser(jsonResponse);
			while (parser.nextToken() != null) {
	        	if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
	        		while (parser.nextToken() != null) {
	        			 if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
	        			 	auList.add((AsanaUser)(parser.readValueAs(AsanaUser.class)));
	        			 }
	        		}
	        	}
			}
		}
		return auList ;	
	}
	
}