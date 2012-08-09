/**
 *	Asana_UserResponseWrapper class
 *
 *	@author		chetanpg59
 *	@version	1.0
 *	@since		15-July-2012
 *
 *	This class would be used for de-serializing the JSON response.
 */
public class Asana_UserResponseWrapper
{
	//the data contained in the response
	public Asana_UserEntries[] data;
	
	//when the REST call returns only a single user in the "data" element
	public class Asana_SingleUserResponse
	{
		public Asana_UserEntries data;
	}
}