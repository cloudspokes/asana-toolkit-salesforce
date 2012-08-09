/**
 *	Asana_TaskEntries class
 *
 *	@author		chetanpg59
 *	@version	1.0
 *	@since		15-July-2012
 *
 *	This class defines the task data
 */
public class Asana_TaskEntries
{
	//The Id of this task.
	public String id;
	
	//User to which this task is assigned, or null if the task is unassigned.
	public Asana_UserEntries assignee {get; set;}
	
	//Scheduling status of this task for the user it is assigned to. One of the following values: inbox, later, today, upcoming
	public String assignee_status {get; set;}
	
	//The time at which this task was created.
	public String created_at;
	
	//True if the task is currently marked complete, false if not.
	public String completed {get; set;}
	
	//The time at which this task was completed, or null if the task is incomplete.
	public String completed_at;
	
	//Date on which this task is due, or null if the task has no due date.
	public String due_on {get; set;}
	
	//Array of users following this task.
	public Asana_UserEntries[] followers;
	
	//Tags specified on this task.
	public Asana_TagEntries[] tags;
	
	//The time at which this task was last modified. 
	public String modified_at;
	
	//Name of the task. This is generally a short sentence fragment that fits on a line in the UI for maximum readability. However, it can be longer.
	public String name {get; set;}
	
	//More detailed, free-form textual information associated with the task.
	public String notes {get; set;}
	
	//Array of projects this task is associated with. These associations can be modified using the addProject and removeProject endpoints.
	public Asana_ProjectEntries[] projects;
	
	//The workspace this task is associated with. Once created, task cannot be moved to a different workspace. This attribute can only be specified at creation time.
	public Asana_WorkspaceEntries workspace;
	
	public String getTaskJSONString()
    {
	    Map<String, Map<String,String>> mapp = new Map<String, Map<String,String>>();
		Map<String, String> mapStrToStr = new Map<String,String>();
		
		if(this.name != null && this.name != '') { mapStrToStr.put('name',this.name); }
		if(this.assignee != null && this.assignee.id != '') { mapStrToStr.put('assignee',this.assignee.id); }
		if(this.assignee_status != null && this.assignee_status != '') { mapStrToStr.put('assignee_status',this.assignee_status); }
		if(this.completed != null && this.completed != '') { mapStrToStr.put('completed',this.completed); }
		if(this.due_on != null && this.due_on != '') { mapStrToStr.put('due_on',this.due_on); }
		if(this.notes != null && this.notes != '') { mapStrToStr.put('notes',this.notes); }
		if(this.workspace != null && this.workspace.id != '') { mapStrToStr.put('workspace',this.workspace.id); }
		
		if(this.followers != null && this.followers.size() > 0) 
		{
			for(Integer i = 0; i < this.followers.size(); i++)
			{ 
				mapStrToStr.put('followers[' + i + ']',this.followers[i].id);
			} 
		}
		
		if(this.projects != null && this.projects.size() > 0) 
		{
			for(Integer i = 0; i < this.projects.size(); i++)
			{ 
				mapStrToStr.put('projects[' + i + ']',this.projects[i].id);
			} 
		}
		
		if(this.tags != null && this.tags.size() > 0) 
		{
			for(Integer i = 0; i < this.tags.size(); i++)
			{ 
				mapStrToStr.put('tags[' + i + ']',this.tags[i].id);
			} 
		}
		
        mapp.put('data',mapStrToStr); 
        String JSONString = JSON.serialize(mapp);
		
		return JSONString;
    }	
}