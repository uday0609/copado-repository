/**
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 * Class Name      : ContactShowNew
 * Author          : Uday Punjani
 * Created Date    : Apr 16, 2026
 * Last Modified By: Uday Punjani
 * Last Modified On: Apr 16, 2026
 * Description     : This class implements for......
 *  
 * Change History  :
 *  Date          │   Author     │   Change
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 *  Apr 16, 2026  │ <Uday Punjani>   │ Initial version
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 */

public class ContactShowNew {

	@AuraEnabled(cacheable=true)
	public static List<Contact> showContact(Integer limits) {
		//System.debug(limits);
		try{
			List<Contact> conList = [SELECT Id,Name,Email FROM Contact LIMIT : limits];
			if(!conList.isEmpty()){
				//System.debug('Data');
				return conList;
			}
		}
		catch(Exception e){
			throw new AuraHandledException(e.getMessage());
		}
		return null;
	}
}