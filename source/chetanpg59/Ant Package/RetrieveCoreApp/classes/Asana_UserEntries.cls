/**
 *	Asana_UserEntries class
 *
 *	@author		chetanpg59
 *	@version	1.0
 *	@since		15-July-2012
 *
 *	This class defines the user data
 */
public class Asana_UserEntries
{
	//ID of the user
	public String id {get; set;}
	
	//The user's name.
	public String name;
	
	//The user's email address.
	public String email;
	
	//Workspaces this user may access. 
	public Asana_WorkspaceEntries[] workspaces;
	
	/*
	public String getUserJSONString()
    {
	    Map<String, Map<String,String>> mapp = new Map<String, Map<String,String>>();
		Map<String, String> mapStrToStr = new Map<String,String>();
		
		if(this.name != null && this.name != '') { mapStrToStr.put('name',this.name); }
		if(this.email != null && this.email != '') { mapStrToStr.put('email',this.email); }
		//if(this.workspace != null && this.workspace.id != '') { mapStrToStr.put('workspace',this.workspace.id); }
		
        mapp.put('data',mapStrToStr); 
        String JSONString = JSON.serialize(mapp);
		
		return JSONString;
    }
    */
}