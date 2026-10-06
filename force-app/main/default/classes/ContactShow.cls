/**
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 * Class Name      : ContactShow
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
 *  May 9 2026    │ <Uday Punjani>   │ Added new Method (add Tasks)
 *  May 14 2026   │ <Uday Punjani>   │ Added new Method (update Tasks)
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 */

public class ContactShow {

	@AuraEnabled(cacheable=true)
	public static List<Contact> showContact() {
		try{
			List<Contact> conList = [SELECT Id,Name,Email,Phone,MailingAddress,Website__c,Pictures__c, (SELECT Id,Type,ActivityDate,Description,Status FROM Tasks) FROM Contact];
			if(!conList.isEmpty()){
				return conList;
			}
		}
		catch(Exception e){
			throw new AuraHandledException(e.getMessage());
		}
		return null;
	}

	@AuraEnabled
	public static void addTask(String contactId, String type, String description, String status , Date activityDate) {
		try{
			Task task = new Task();
			task.WhoId = contactId;
			task.Type = type;
			task.Subject = type;
			task.Description = description;
			task.Status = 'Not Started';
			task.ActivityDate = System.today();
			insert task;
		}
		catch(Exception e){
			System.debug('Exception in addTask: ' + e.getMessage());
			throw new AuraHandledException(e.getMessage());
		}
	}

	@AuraEnabled
	public static void updateTasks(List<Id> taskIds) {
		try {
			System.debug('IDS    ___>'+taskIds);
			List<Task> tasksToUpdate = new List<Task>();
			for(Id tid : taskIds) {
				System.debug('Task Id: ' + tid);
				tasksToUpdate.add(new Task(Id = tid, Status = 'Completed'));
			}
			if(!tasksToUpdate.isEmpty()){
				update tasksToUpdate;
			}
		} catch (Exception e) {
			throw new AuraHandledException('Error updating tasks: ' + e.getMessage());
		}
	}
}