public class ContactTriggerHandler {

    public static Set<Id> processedContacts = new Set<Id>();

    public static void beforeInsert(List<Contact> conList){
        //ContactHelper.validatePhone(conList);
        //ContactHelper.uniqueEmail(conList);
    }

    public static void afterInsert(List<Contact> conList){
        //ContactHelper.updateAccountContactFields(conList,null);
        //ContactHelper.updateTotalSalaryOnNewContact(conList,NULL);
        //ContactHelper.updateAccountScore(conList, null);
    }
    
    public static void beforeUpdate(List<Contact> conList, Map<Id,Contact> oldMap){
    	//ContactHelper.trackEmailChange(conList, oldMap);
    }

    public static void afterUpdate(List<Contact> conList, Map<Id,Contact> oldMap){
        //ContactHelper.updateAccountContactFields(conList, oldMap);
        //ContactHelper.updateTotalSalaryOnNewContact(conList,oldMap);
        //ContactHelper.updateAccountScore(conList, oldMap);
        //ContactHelper.insertContactLog(conList,oldMap);
    }
    
    public static void beforeDelete(Map<Id,Contact> oldMap){
        
    }
    

    public static void afterDelete(List<Contact> conList){
        //ContactHelper.updateAccountContactFields(conList,null);
  		//ContactHelper.updateTotalSalaryOnNewContact(conList,null);
  		//ContactHelper.updateAccountScore(conList,null);
    }
    
    public static void afterUnDelete(List<Contact> conList){
        //ContactHelper.updateAccountContactFields(conList,null);
       //ContactHelper.updateAccountScore(conList, null);
        
    }
    
}