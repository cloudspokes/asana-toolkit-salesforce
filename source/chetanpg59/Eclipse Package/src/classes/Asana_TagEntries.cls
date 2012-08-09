/**
 *	Asana_TagEntries class
 *
 *	@author		chetanpg59
 *	@version	1.0
 *	@since		15-July-2012
 *
 *	This class defines the tag data
 */
public class Asana_TagEntries
{
	//ID of the tag
	public String id {get; set;}
	
	//Name of the tag. This is generally a short sentence fragment that fits on a line in the UI for maximum readability. However, it can be longer.
	public String name;
	
	//The time at which this tag was created.
	public DateTime created_at;
	
	//Array of users following this tag.
	public Asana_UserEntries[] followers;
	
	//More detailed, free-form textual information associated with the project.
	public String notes;
	
	//The workspace this tag is associated with. Once created, tag cannot be moved to a different workspace. This attribute can only be specified at creation time.
	public Asana_WorkspaceEntries workspace;
	
	public String getTagJSONString()
    {
	    Map<String, Map<String,String>> mapp = new Map<String, Map<String,String>>();
		Map<String, String> mapStrToStr = new Map<String,String>();
		
		if(this.name != null && this.name != '') { mapStrToStr.put('name',this.name); }
		if(this.notes != null && this.notes != '') { mapStrToStr.put('notes',this.notes); }
		if(this.workspace != null && this.workspace.id != '') { mapStrToStr.put('workspace',this.workspace.id); }
		
		if(this.followers != null && this.followers.size() > 0) 
		{
			for(Integer i = 0; i < this.followers.size(); i++)
			{ 
				mapStrToStr.put('followers[' + i + ']',this.followers[i].id);
			} 
		}
		
        mapp.put('data',mapStrToStr); 
        String JSONString = JSON.serialize(mapp);
		
		return JSONString;
    }
}