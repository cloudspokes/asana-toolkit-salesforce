/**
 *	Asana_WorkspaceEntries class
 *
 *	@author		chetanpg59
 *	@version	1.0
 *	@since		15-July-2012
 *
 *	This class defines the workspace data
 */
public class Asana_WorkspaceEntries
{
	//ID of the workspace.
	public String id;
	
	//Name of the workspace.
	public String name;
	
	public String getWorkspaceJSONString()
    {
	    Map<String, Map<String,String>> mapp = new Map<String, Map<String,String>>();
		Map<String, String> mapStrToStr = new Map<String,String>();
		
		if(this.name != null && this.name != '') { mapStrToStr.put('name',this.name); }
		
        mapp.put('data',mapStrToStr); 
        String JSONString = JSON.serialize(mapp);
		
		return JSONString;
    }
}