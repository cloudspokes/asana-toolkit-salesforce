/**
 *	Asana_WorkspaceResponseWrapper class
 *
 *	@author		chetanpg59
 *	@version	1.0
 *	@since		15-July-2012
 *
 *	This class would be used for de-serializing the JSON response.
 */
public class Asana_WorkspaceResponseWrapper
{
	//the data contained in the response
	public Asana_WorkspaceEntries[] data;
	
	//when the REST call returns only a single workspace in the "data" element
	public class Asana_SingleWorkspaceResponse
	{
		public Asana_WorkspaceEntries data;
	}
}