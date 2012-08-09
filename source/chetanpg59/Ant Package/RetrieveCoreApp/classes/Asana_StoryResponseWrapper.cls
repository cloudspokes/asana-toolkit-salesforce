/**
 *	Asana_StoryResponseWrapper class
 *
 *	@author		chetanpg59
 *	@version	1.0
 *	@since		15-July-2012
 *
 *	This class would be used for de-serializing the JSON response.
 */
public class Asana_StoryResponseWrapper
{
	//the data contained in the response
	public Asana_StoryEntries[] data;
	
	//when the REST call returns only a single story in the "data" element
	public class Asana_SingleStoryResponse
	{
		public Asana_StoryEntries data;
	}
}