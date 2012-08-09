/**
 *	Asana_TaskResponseWrapper class
 *
 *	@author		chetanpg59
 *	@version	1.0
 *	@since		15-July-2012
 *
 *	This class would be used for de-serializing the JSON response.
 */
public class Asana_TaskResponseWrapper
{
	//the data contained in the response
	public Asana_TaskEntries[] data;
	
	//when the REST call returns only a single task in the "data" element
	public class Asana_SingleTaskResponse
	{
		public Asana_TaskEntries data;
	}
}