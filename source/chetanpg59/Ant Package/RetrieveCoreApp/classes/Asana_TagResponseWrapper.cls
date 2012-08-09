/**
 *	Asana_TagResponseWrapper class
 *
 *	@author		chetanpg59
 *	@version	1.0
 *	@since		15-July-2012
 *
 *	This class would be used for de-serializing the JSON response.
 */
public class Asana_TagResponseWrapper
{
	//the data contained in the response
	public Asana_TagEntries[] data;
	
	//when the REST call returns only a single tag in the "data" element
	public class Asana_SingleTagResponse
	{
		public Asana_TagEntries data;
	}
}