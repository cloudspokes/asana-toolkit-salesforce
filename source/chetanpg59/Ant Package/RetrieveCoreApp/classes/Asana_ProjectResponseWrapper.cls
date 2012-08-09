/**
 *	Asana_ProjectResponseWrapper class
 *
 *	@author		chetanpg59
 *	@version	1.0
 *	@since		15-July-2012
 *
 *	This class would be used for de-serializing the JSON response.
 */
public class Asana_ProjectResponseWrapper
{
	//the data contained in the response
	public Asana_ProjectEntries[] data;
	
	//when the REST call returns only a single project in the "data" element
	public class Asana_SingleProjectResponse
	{
		public Asana_ProjectEntries data;
	}
}