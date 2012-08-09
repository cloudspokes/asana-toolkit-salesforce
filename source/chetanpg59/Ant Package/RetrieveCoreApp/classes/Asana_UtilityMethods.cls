public class Asana_UtilityMethods
{
    public static String getUserJSONString()
    {
        Asana_UserEntries user = getUser();
        Map<String,Asana_UserEntries> mapp = new Map<String,Asana_UserEntries>();
        mapp.put('data',user);
        return JSON.serialize(mapp);
    }
    
    public static String getUsersJSONString()
    {
    	List<Asana_UserEntries> users = new List<Asana_UserEntries>();
    	for(Integer i = 0; i < 3 ; i++)
    	{
        	Asana_UserEntries user = getUser();
        	users.add(user);
    	}
    	Map<String,List<Asana_UserEntries>> mapp = new Map<String,List<Asana_UserEntries>>();
    	mapp.put('data',users);
        return JSON.serialize(mapp);
    }
    
    public static String getWorkspaceJSONString()
    {
        Asana_WorkspaceEntries workspace = getWorkspace();
        Map<String,Asana_WorkspaceEntries> mapp = new Map<String,Asana_WorkspaceEntries>();
        mapp.put('data',workspace);
        return JSON.serialize(mapp);       
    }
    
    public static String getWorkspacesJSONString()
    {
    	List<Asana_WorkspaceEntries> workspaces = new List<Asana_WorkspaceEntries>();
    	for(Integer i = 0; i < 3 ; i++)
    	{
        	Asana_WorkspaceEntries workspace = getWorkspace();
        	workspaces.add(workspace);
    	}
    	Map<String,List<Asana_WorkspaceEntries>> mapp = new Map<String,List<Asana_WorkspaceEntries>>();
    	mapp.put('data',workspaces);
        return JSON.serialize(mapp);
    }
    
    public static String getTagJSONString()
    {
        Asana_TagEntries tag = getTag();
        Map<String,Asana_TagEntries> mapp = new Map<String,Asana_TagEntries>();
        mapp.put('data',tag);
        return JSON.serialize(mapp);     
    }
    
    public static String getTagsJSONString()
    {
        List<Asana_TagEntries> tags = new List<Asana_TagEntries>();
    	for(Integer i = 0; i < 3 ; i++)
    	{
        	Asana_TagEntries tag = getTag();
        	tags.add(tag);
    	}
    	Map<String,List<Asana_TagEntries>> mapp = new Map<String,List<Asana_TagEntries>>();
    	mapp.put('data',tags);
        return JSON.serialize(mapp);     
    }
    
    public static String getProjectJSONString()
    {
        Asana_ProjectEntries project = getProject();
        Map<String,Asana_ProjectEntries> mapp = new Map<String,Asana_ProjectEntries>();
        mapp.put('data',project);
        return JSON.serialize(mapp);
    }
    
    public static String getProjectsJSONString()
    {
        List<Asana_ProjectEntries> projects = new List<Asana_ProjectEntries>();
    	for(Integer i = 0; i < 3 ; i++)
    	{
        	Asana_ProjectEntries project = getProject();
        	projects.add(project);
    	}
    	Map<String,List<Asana_ProjectEntries>> mapp = new Map<String,List<Asana_ProjectEntries>>();
    	mapp.put('data',projects);
        return JSON.serialize(mapp);     
    }
    
    public static String getTaskJSONString()
    {
        Asana_TaskEntries task = getTask();
        Map<String,Asana_TaskEntries> mapp = new Map<String,Asana_TaskEntries>();
        mapp.put('data',task);
        return JSON.serialize(mapp);
    }
    
    public static String getTasksJSONString()
    {
        List<Asana_TaskEntries> tasks = new List<Asana_TaskEntries>();
    	for(Integer i = 0; i < 3 ; i++)
    	{
        	Asana_TaskEntries task = getTask();
        	tasks.add(task);
    	}
    	Map<String,List<Asana_TaskEntries>> mapp = new Map<String,List<Asana_TaskEntries>>();
    	mapp.put('data',tasks);
        return JSON.serialize(mapp);     
    }
    
    public static String getStoryJSONString()
    {
        Asana_StoryEntries story = getStory();
        Map<String,Asana_StoryEntries> mapp = new Map<String,Asana_StoryEntries>();
        mapp.put('data',story);
        return JSON.serialize(mapp);
    }
    
    public static String getStoriesJSONString()
    {
        List<Asana_StoryEntries> stories = new List<Asana_StoryEntries>();
    	for(Integer i = 0; i < 3 ; i++)
    	{
        	Asana_StoryEntries story = getStory();
        	stories.add(story);
    	}
    	Map<String,List<Asana_StoryEntries>> mapp = new Map<String,List<Asana_StoryEntries>>();
    	mapp.put('data',stories);
        return JSON.serialize(mapp);     
    }
    
    public static Asana_UserEntries getUser()
    {
        Asana_UserEntries user = new Asana_UserEntries();
        
        user.id = '12312';
        user.email = 'someemail@emaildomain.com';
        user.name = 'Some Name';
        
        user.workspaces = new List<Asana_WorkspaceEntries>();
        for(Integer i = 0 ; i < 2; i++)
        {
            user.workspaces.add(getWorkspace());
        }
        
        return user;
    }
    
    public static Asana_WorkspaceEntries getWorkspace()
    {
        Asana_WorkspaceEntries workspace = new Asana_WorkspaceEntries();
        
        workspace.id = '123123';
        workspace.name = 'Some Workspace';
        
        return workspace;
    }
    
    public static Asana_TagEntries getTag()
    {
        Asana_TagEntries tag = new Asana_TagEntries();
        
        tag.id = '129387';
        tag.name = 'Some Tag';
        tag.notes = 'Some Tag Notes';
        tag.workspace = getWorkspace();
        
        tag.followers = new List<Asana_UserEntries>();
        for(Integer i = 0 ; i < 2; i++)
        {
            tag.followers.add(getUser());
        }
        
        return tag;
    }
    
    public static Asana_ProjectEntries getProject()
    {
        Asana_ProjectEntries project = new Asana_ProjectEntries();
        
        project.id = '981273';
        project.name = 'Some Project';
        project.archived = false;
        project.notes = 'Some Notes on the Project';
        project.workspace = getWorkspace();
        
        project.followers = new List<Asana_UserEntries>();
        for(Integer i = 0 ; i < 2; i++)
        {
            project.followers.add(getUser());
        }
        
        return project;
    }
    
    public static Asana_TaskEntries getTask()
    {
        Asana_TaskEntries task = new Asana_TaskEntries();
        
        task.id = '234235';
        task.assignee = getUser();
        task.assignee_status = 'inbox';
        task.completed = 'false';
        task.name = 'Some Name';
        task.notes = 'Some Notes';
        task.workspace = getWorkspace();
        
        task.followers = new List<Asana_UserEntries>();
        for(Integer i = 0 ; i < 2; i++)
        {
            task.followers.add(getUser());
        }
        
        task.projects = new List<Asana_ProjectEntries>();
        for(Integer i = 0 ; i < 2; i++)
        {
            task.projects.add(getProject());
        }
        
        task.tags = new List<Asana_TagEntries>();
        for(Integer i = 0 ; i < 2; i++)
        {
            task.tags.add(getTag());
        }
        
        return task;
    }
    
    public static Asana_StoryEntries getStory()
    {
        Asana_StoryEntries story = new Asana_StoryEntries();
        
        story.id = '123523';
        story.name = 'Some Story Name';
        story.text = 'Some Story Text';
        story.source = 'Web';
        story.type = 'System';
        
		
        Asana_StoryAssociation assoc = new Asana_StoryAssociation();
        assoc.id = '12312';
        assoc.name = 'Associated to a Task';
        story.target = assoc;
        
        
        story.created_at = System.now();
        story.created_by = getUser();
        
        return story;
    }
}