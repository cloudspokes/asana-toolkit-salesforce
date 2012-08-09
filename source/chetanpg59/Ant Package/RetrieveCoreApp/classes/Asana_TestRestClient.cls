/**
 *	Test_AsanaRestClient class
 *
 *	@author		chetanpg59
 *	@version	1.8
 *	@since		18-July-2012
 *
 *	This is the test class for the asana rest client class.
 */
@isTest(SeeAllData=false)
public class Asana_TestRestClient
{
	static testMethod void testGetUserById()
	{
		Test.startTest();
		setupTestApiKey();
		Asana_UserEntries user = AsanaRestClient.getUserById('12312');
		System.assertEquals(user.name, 'Some Name');
		System.assertEquals(user.email, 'someemail@emaildomain.com');
		Test.stopTest();
	}
	
	static testMethod void testGetMyUser()
	{
		Test.startTest();
		setupTestApiKey();
		Asana_UserEntries user = AsanaRestClient.getMyUser();
		System.assertEquals(user.name, 'Some Name');
		System.assertEquals(user.email, 'someemail@emaildomain.com');
		Test.stopTest();
	}
	
	static testMethod void testGetAllUsers()
	{
		Test.startTest();
		setupTestApiKey();
		List<Asana_UserEntries> users = AsanaRestClient.getAllUsers();
		System.assertEquals(users.size(),3);
		System.assertEquals(users[0].name, 'Some Name');
		System.assertEquals(users[0].email, 'someemail@emaildomain.com');
		Test.stopTest();
	}
	
	static testMethod void testGetUsersByWorkspace()
	{
		Test.startTest();
		setupTestApiKey();
		Asana_WorkspaceEntries workspace = Asana_UtilityMethods.getWorkspace();
		List<Asana_UserEntries> users = AsanaRestClient.getUsersByWorkspace(workspace.id);
		System.assertEquals(users.size(),3);
		System.assertEquals(users[0].name, 'Some Name');
		System.assertEquals(users[0].email, 'someemail@emaildomain.com');
		Test.stopTest();
	}
	
	static testMethod void testCreateTask()
	{
		Test.startTest();
		setupTestApiKey();
		Asana_TaskEntries task = Asana_UtilityMethods.getTask();
		Asana_TaskEntries createdTask = AsanaRestClient.createTask(task);
		System.assertEquals(createdTask.assignee_status, 'inbox');
		System.assertEquals(createdTask.name,'Some Name');
        System.assertEquals(createdTask.notes,'Some Notes');
		Test.stopTest();
	}
	
	static testMethod void testCreateTaskInWorkspace()
	{
		Test.startTest();
		setupTestApiKey();
		Asana_WorkspaceEntries workspace = Asana_UtilityMethods.getWorkspace();
		Asana_TaskEntries task = Asana_UtilityMethods.getTask();
		Asana_TaskEntries createdTask = AsanaRestClient.createTaskInWorkspace(task,workspace.id);
		System.assertEquals(createdTask.assignee_status, 'inbox');
		System.assertEquals(createdTask.name,'Some Name');
        System.assertEquals(createdTask.notes,'Some Notes');
		Test.stopTest();
	}
	
	static testMethod void testGetTaskById()
	{
		Test.startTest();
		setupTestApiKey();
		Asana_TaskEntries task = AsanaRestClient.getTaskById('234235');
		System.assertEquals(task.assignee_status, 'inbox');
		System.assertEquals(task.name,'Some Name');
        System.assertEquals(task.notes,'Some Notes');
		Test.stopTest();
	}
	
	static testMethod void testUpdateTask()
	{
		Test.startTest();
		setupTestApiKey();
		Asana_TaskEntries task = Asana_UtilityMethods.getTask();
		Asana_TaskEntries updatedTask = AsanaRestClient.updateTask(task);
		System.assertEquals(updatedTask.assignee_status, 'inbox');
		System.assertEquals(updatedTask.name,'Some Name');
        System.assertEquals(updatedTask.notes,'Some Notes');
		Test.stopTest();
	}
	
	static testMethod void testGetTasksByProject()
	{
		Test.startTest();
		setupTestApiKey();
		Asana_ProjectEntries project = Asana_UtilityMethods.getProject();
		List<Asana_TaskEntries> tasks = AsanaRestClient.getTasksByProject(project.id);
		System.assertEquals(tasks.size(),3);
		System.assertEquals(tasks[0].assignee_status, 'inbox');
		System.assertEquals(tasks[0].name,'Some Name');
        System.assertEquals(tasks[0].notes,'Some Notes');
		Test.stopTest();
	}
	
	static testMethod void testGetTasksByWorkspace()
	{
		Test.startTest();
		setupTestApiKey();
		Asana_WorkspaceEntries workspace = Asana_UtilityMethods.getWorkspace();
		List<Asana_TaskEntries> tasks = AsanaRestClient.getTasksByWorkspace(workspace.id,'me');
		System.assertEquals(tasks.size(),3);
		System.assertEquals(tasks[0].assignee_status, 'inbox');
		System.assertEquals(tasks[0].name,'Some Name');
        System.assertEquals(tasks[0].notes,'Some Notes');
		Test.stopTest();
	}
	
	static testMethod void testGetStoriesOnTask()
	{
		Test.startTest();
		setupTestApiKey();
		Asana_TaskEntries task = Asana_UtilityMethods.getTask();
		List<Asana_StoryEntries> stories = AsanaRestClient.getStoriesOnTask(task.id);
		System.assertEquals(stories.size(),3);
		System.assertEquals(stories[0].name, 'Some Story Name');
		System.assertEquals(stories[0].text,'Some Story Text');
        System.assertEquals(stories[0].source,'Web');
		Test.stopTest();
	}
	
	static testMethod void testPostCommentOnTask()
	{
		Test.startTest();
		setupTestApiKey();
		Asana_StoryEntries story = Asana_UtilityMethods.getStory();
		Asana_TaskEntries task = Asana_UtilityMethods.getTask();
		Asana_StoryEntries createdStory = AsanaRestClient.postCommentOnTask(story,task.id);
		System.assertEquals(story.name, 'Some Story Name');
		System.assertEquals(story.text,'Some Story Text');
        System.assertEquals(story.source,'Web');
		Test.stopTest();
	}
	
	static testMethod void testGetTagsOnTask()
	{
		Test.startTest();
		setupTestApiKey();
		Asana_TaskEntries task = Asana_UtilityMethods.getTask();
		List<Asana_TagEntries> tags = AsanaRestClient.getTagsOnTask(task.id);
		System.assertEquals(tags.size(),3);
		System.assertEquals(tags[0].name, 'Some Tag');
		System.assertEquals(tags[0].notes, 'Some Tag Notes');
		System.assertEquals(tags[0].followers.size(), 2);
		Test.stopTest();
	}
	
	static testMethod void testAddTagToTask()
	{
		Test.startTest();
		setupTestApiKey();
		Asana_TaskEntries task = Asana_UtilityMethods.getTask();
		Asana_TagEntries tag = Asana_UtilityMethods.getTag();
		Asana_TagEntries createdTag = AsanaRestClient.addTagToTask(tag,task.id);
		System.assertEquals(createdTag.name, 'Some Tag');
		System.assertEquals(createdTag.notes, 'Some Tag Notes');
		System.assertEquals(createdTag.followers.size(), 2);
		Test.stopTest();
	}
	
	static testMethod void testRemoveTagFromTask()
	{
		Test.startTest();
		setupTestApiKey();
		Asana_TaskEntries task = Asana_UtilityMethods.getTask();
		Asana_TagEntries tag = Asana_UtilityMethods.getTag();
		Asana_TagEntries createdTag = AsanaRestClient.removeTagFromTask(tag,task.id);
		System.assertEquals(createdTag.name, 'Some Tag');
		System.assertEquals(createdTag.notes, 'Some Tag Notes');
		System.assertEquals(createdTag.followers.size(), 2);
		Test.stopTest();
	}
	
	static testMethod void testCreateProject()
	{
		Test.startTest();
		setupTestApiKey();
		Asana_ProjectEntries project = Asana_UtilityMethods.getProject();
		Asana_ProjectEntries createdProject = AsanaRestClient.createProject(project);
		System.assertEquals(createdProject.name, 'Some Project');
		System.assertEquals(createdProject.notes, 'Some Notes on the Project');
		System.assertEquals(createdProject.archived, false);
		Test.stopTest();
	}
	
	static testMethod void testCreateProjectInWorkspace()
	{
		Test.startTest();
		setupTestApiKey();
		Asana_WorkspaceEntries workspace = Asana_UtilityMethods.getWorkspace();
		Asana_ProjectEntries project = Asana_UtilityMethods.getProject();
		Asana_ProjectEntries createdProject = AsanaRestClient.createProjectInWorkspace(project,workspace.id);
		System.assertEquals(createdProject.name, 'Some Project');
		System.assertEquals(createdProject.notes, 'Some Notes on the Project');
		System.assertEquals(createdProject.archived, false);
		Test.stopTest();
	}
	
	static testMethod void testGetProjectById()
	{
		Test.startTest();
		setupTestApiKey();
		Asana_ProjectEntries project = AsanaRestClient.getProjectById('981273');
		System.assertEquals(project.name, 'Some Project');
		System.assertEquals(project.notes, 'Some Notes on the Project');
		System.assertEquals(project.archived, false);
		Test.stopTest();
	}
	
	static testMethod void testUpdateProject()
	{
		Test.startTest();
		setupTestApiKey();
		Asana_ProjectEntries project = Asana_UtilityMethods.getProject();
		Asana_ProjectEntries updatedProject = AsanaRestClient.updateProject(project);
		System.assertEquals(updatedProject.name, 'Some Project');
		System.assertEquals(updatedProject.notes, 'Some Notes on the Project');
		System.assertEquals(updatedProject.archived, false);
		Test.stopTest();
	}
	
	static testMethod void testGetTasksOnProject()
	{
		Test.startTest();
		setupTestApiKey();
		Asana_ProjectEntries project = Asana_UtilityMethods.getProject();
		List<Asana_TaskEntries> tasks = AsanaRestClient.getTasksOnProject(project.id);
		System.assertEquals(tasks.size(),3);
		System.assertEquals(tasks[0].assignee_status, 'inbox');
		System.assertEquals(tasks[0].name,'Some Name');
        System.assertEquals(tasks[0].notes,'Some Notes');
		Test.stopTest();
	}
		
	static testMethod void testGetProjectsInWorkspace()
	{
		Test.startTest();
		setupTestApiKey();
		Asana_WorkspaceEntries workspace = Asana_UtilityMethods.getWorkspace();
		List<Asana_ProjectEntries> projects = AsanaRestClient.getProjectsInWorkspace(workspace.id);
		System.assertEquals(projects.size(),3);
		System.assertEquals(projects[0].name, 'Some Project');
		System.assertEquals(projects[0].notes, 'Some Notes on the Project');
		System.assertEquals(projects[0].archived, false);
		Test.stopTest();
	}
	
	static testMethod void testGetAllProjects()
	{
		Test.startTest();
		setupTestApiKey();
		List<Asana_ProjectEntries> projects = AsanaRestClient.getAllProjects();
		System.assertEquals(projects.size(),3);
		System.assertEquals(projects[0].name, 'Some Project');
		System.assertEquals(projects[0].notes, 'Some Notes on the Project');
		System.assertEquals(projects[0].archived, false);
		Test.stopTest();
	}
	
	static testMethod void testCreateTagInWorkspace()
	{
		Test.startTest();
		setupTestApiKey();
		Asana_WorkspaceEntries workspace = Asana_UtilityMethods.getWorkspace();
		Asana_TagEntries tag = Asana_UtilityMethods.getTag();
		Asana_TagEntries createdTag = AsanaRestClient.createTagInWorkspace(tag,workspace.id);
		System.assertEquals(createdTag.name, 'Some Tag');
		System.assertEquals(createdTag.notes, 'Some Tag Notes');
        System.assertEquals(createdTag.followers.size(), 2);
		Test.stopTest();
	}
	
	static testMethod void testCreateTag()
	{
		Test.startTest();
		setupTestApiKey();
		Asana_TagEntries tag = Asana_UtilityMethods.getTag();
		Asana_TagEntries createdTag = AsanaRestClient.createTag(tag);
		System.assertEquals(createdTag.name, 'Some Tag');
		System.assertEquals(createdTag.notes, 'Some Tag Notes');
        System.assertEquals(createdTag.followers.size(), 2);
		Test.stopTest();
	}
	
	static testMethod void testGetTagById()
	{
		Test.startTest();
		setupTestApiKey();
		Asana_TagEntries tag = AsanaRestClient.getTagById('129387');
		System.assertEquals(tag.name, 'Some Tag');
		System.assertEquals(tag.notes,'Some Tag Notes');
		System.assertEquals(tag.followers.size(), 2);
		Test.stopTest();
	}
	
	static testMethod void testUpdateTag()
	{
		Test.startTest();
		setupTestApiKey();
		Asana_TagEntries tag = Asana_UtilityMethods.getTag();
		Asana_TagEntries updatedTag = AsanaRestClient.updateTag(tag);
		System.assertEquals(updatedTag.name, 'Some Tag');
		System.assertEquals(updatedTag.notes, 'Some Tag Notes');
		Test.stopTest();
	}
	
	static testMethod void testGetTasksByTags()
	{
		Test.startTest();
		setupTestApiKey();
		Asana_TagEntries tag = Asana_UtilityMethods.getTag();
		List<Asana_TaskEntries> tasks = AsanaRestClient.getTasksByTag(tag.id);
		System.assertEquals(tasks.size(),3);
		System.assertEquals(tasks[0].name, 'Some Name');
		System.assertEquals(tasks[0].notes, 'Some Notes');
		System.assertEquals(tasks[0].assignee_status, 'inbox');
		Test.stopTest();
	}
	
	static testMethod void testGetAllTags()
	{
		Test.startTest();
		setupTestApiKey();
		List<Asana_TagEntries> tags = AsanaRestClient.getAllTags();
		System.assertEquals(tags.size(),3);
		System.assertEquals(tags[0].name, 'Some Tag');
		System.assertEquals(tags[0].notes, 'Some Tag Notes');
		Test.stopTest();
	}
	
	static testMethod void testGetTagsByWorkspace()
	{
		Test.startTest();
		setupTestApiKey();
		Asana_WorkspaceEntries workspace = Asana_UtilityMethods.getWorkspace();
		List<Asana_TagEntries> tags = AsanaRestClient.getTagsByWorkspace(workspace.id);
		System.assertEquals(tags.size(),3);
		System.assertEquals(tags[0].name, 'Some Tag');
		System.assertEquals(tags[0].notes, 'Some Tag Notes');
		Test.stopTest();
	}
	
	static testMethod void testGetCommentsOnTask()
	{
		Test.startTest();
		setupTestApiKey();
		Asana_TaskEntries task = Asana_UtilityMethods.getTask();
		List<Asana_StoryEntries> stories = AsanaRestClient.getCommentsOnTask(task.id);
		System.assertEquals(stories.size(),3);
		System.assertEquals(stories[0].name, 'Some Story Name');
		System.assertEquals(stories[0].text, 'Some Story Text');
		System.assertEquals(stories[0].source,'Web');
		Test.stopTest();
	}
	
	static testMethod void testGetCommentsOnProject()
	{
		Test.startTest();
		setupTestApiKey();
		Asana_ProjectEntries project = Asana_UtilityMethods.getProject();
		List<Asana_StoryEntries> stories = AsanaRestClient.getCommentsOnProject(project.id);
		System.assertEquals(stories.size(),3);
		System.assertEquals(stories[0].name, 'Some Story Name');
		System.assertEquals(stories[0].text, 'Some Story Text');
		System.assertEquals(stories[0].source,'Web');
		Test.stopTest();
	}
	
	static testMethod void testGetStoryById()
	{
		Test.startTest();
		setupTestApiKey();
		Asana_StoryEntries story = AsanaRestClient.getStoryById('12312');
		System.assertEquals(story.name, 'Some Story Name');
		System.assertEquals(story.text,'Some Story Text');
		System.assertEquals(story.source, 'Web');
		Test.stopTest();
	}
	
	static testMethod void testPostCommentOnProject()
	{
		Test.startTest();
		setupTestApiKey();
		Asana_StoryEntries story = Asana_UtilityMethods.getStory();
		Asana_ProjectEntries project = Asana_UtilityMethods.getProject();
		Asana_StoryEntries storyy = AsanaRestClient.commentOnProject(story, project.id);
		System.assertEquals(storyy.name, 'Some Story Name');
		System.assertEquals(storyy.text,'Some Story Text');
		System.assertEquals(storyy.source, 'Web');
		//System.assertEquals(storry.type,'System');
		Test.stopTest();
	}
	
	static testMethod void testPostCommentOnTask1()
	{
		Test.startTest();
		setupTestApiKey();
		Asana_StoryEntries story = Asana_UtilityMethods.getStory();
		Asana_TaskEntries task = Asana_UtilityMethods.getTask();
		Asana_StoryEntries storyy = AsanaRestClient.commentOnTask(story, task.id);
		System.assertEquals(storyy.name, 'Some Story Name');
		System.assertEquals(storyy.text,'Some Story Text');
		System.assertEquals(storyy.source, 'Web');
		//System.assertEquals(storry.type,'System');
		Test.stopTest();
	}
	
	static testMethod void testGetAllWorkspaces()
	{
		Test.startTest();
		setupTestApiKey();
		List<Asana_WorkspaceEntries> workspaces = AsanaRestClient.getAllWorkspaces();
		System.assertEquals(workspaces.size(),3);
		System.assertEquals(workspaces[0].name, 'Some Workspace');
		Test.stopTest();
	}
	
	static testMethod void testUpdateWorkspace()
	{
		Test.startTest();
		setupTestApiKey();
		Asana_WorkspaceEntries workspace = Asana_UtilityMethods.getWorkspace();
		Asana_WorkspaceEntries updatedWorkspace = AsanaRestClient.updateWorkspace(workspace);
		System.assertEquals(updatedWorkspace.name, 'Some Workspace');
		Test.stopTest();
	}
	
	static testMethod void testAllWrapperClasses()
	{
		//for some reason, the wrapper classes were not initialized during the test runs
		//hence writing this mock test class to just instantiate and test those wrapper classes
		Asana_ProjectResponseWrapper prjWrap = new Asana_ProjectResponseWrapper();
		Asana_ProjectResponseWrapper.Asana_SingleProjectResponse prjSingleWrap = new Asana_ProjectResponseWrapper.Asana_SingleProjectResponse();
		
		Asana_UserResponseWrapper userWrap = new Asana_UserResponseWrapper();
		Asana_UserResponseWrapper.Asana_SingleUserResponse userSingleWrap = new Asana_UserResponseWrapper.Asana_SingleUserResponse();
		
		Asana_TaskResponseWrapper taskWrap = new Asana_TaskResponseWrapper();
		Asana_TaskResponseWrapper.Asana_SingleTaskResponse taskSingleWrap = new Asana_TaskResponseWrapper.Asana_SingleTaskResponse();
		
		Asana_WorkspaceResponseWrapper wspaceWrap = new Asana_WorkspaceResponseWrapper();
		Asana_WorkspaceResponseWrapper.Asana_SingleWorkspaceResponse wspcSingleWrap = new Asana_WorkspaceResponseWrapper.Asana_SingleWorkspaceResponse();
		
		Asana_TagResponseWrapper tagWrap = new Asana_TagResponseWrapper();
		Asana_TagResponseWrapper.Asana_SingleTagResponse tgSingleWrap = new Asana_TagResponseWrapper.Asana_SingleTagResponse();
		
		Asana_StoryResponseWrapper strWrap = new Asana_StoryResponseWrapper();
		Asana_StoryResponseWrapper.Asana_SingleStoryResponse srySingleWrap = new Asana_StoryResponseWrapper.Asana_SingleStoryResponse();
	}
	
	static void setupTestApiKey()
	{
		Asana_Config__c config = new Asana_Config__c();
		config.Name = 'API Key';
		config.API_Key__c = 'aas23.112312as35dfas';
		insert config;
	}
}