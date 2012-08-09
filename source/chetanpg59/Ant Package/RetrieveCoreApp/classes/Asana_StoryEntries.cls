/**
 *	Asana_StoryEntries class
 *
 *	@author		chetanpg59
 *	@version	1.0
 *	@since		15-July-2012
 *
 *	This class defines the story data
 */
public class Asana_StoryEntries
{
	//id of the story record
	public String id;
	
	//name of the story
	public String name;
	
	//The time at which this story was created.
	public DateTime created_at;
	
	//The user who created the story.
	public Asana_UserEntries created_by;
	
	//Human-readable text for the story or comment.
	public String text;
	
	//The object this story is associated with. May be a task or a project.
	public Asana_StoryAssociation target;
	
	//The component of the Asana product the user used to trigger the story. Valid values are: web, email, mobile, api, unknown
	public String source;
	
	//The type of story this is. Valid values are: comment, system
	public String type;
	
	public String getStoryJSONString()
    {
	    Map<String, Map<String,String>> mapp = new Map<String, Map<String,String>>();
		Map<String, String> mapStrToStr = new Map<String,String>();
		
		if(this.name != null && this.name != '') { mapStrToStr.put('name',this.name); }
		if(this.text != null && this.text != '') { mapStrToStr.put('text',this.text); }
		if(this.source != null && this.source != '') { mapStrToStr.put('source',this.source); }
		if(this.type != null && this.type != '') { mapStrToStr.put('type',this.type); }
		if(this.target != null && this.target.id != '') { mapStrToStr.put('target',this.target.id); }
		
        mapp.put('data',mapStrToStr); 
        String JSONString = JSON.serialize(mapp);
		
		return JSONString;
    }
}