/**
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 * Class Name      : CreateContactController
 * Author          : Uday Punjani
 * Created Date    : Apr 7, 2026
 * Last Modified By: Uday Punjani
 * Last Modified On: Apr 7, 2026
 * Description     : This class implements for creating the contact through the data entered in the lwc form
 *  
 * Change History  :
 *  Date          │   Author     │   Change
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 *  Apr 7, 2026  │ Uday Punjani   │ Initial version
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 */

public with sharing class CreateContactController {

	@AuraEnabled
	public static Contact CreateContacts(String firstName, String lastName,String phone,String email) {
		Contact con;
		try{
			System.debug('inside create contact');
			con = new Contact(FirstName = firstName, LastName = lastName, Phone = phone, Email = email);
			insert con;
			System.debug('contact:'+ con);
		}
		catch(Exception e){
			System.debug('Exception  '+ e.getMessage());
			throw new AuraHandledException(e.getMessage());
		}
		return con;
	}
	
}