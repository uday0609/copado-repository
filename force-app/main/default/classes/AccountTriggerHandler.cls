public class AccountTriggerHandler {

    public static void beforeInsert(List<Account> newList){
        //AccountHelper.setDescription(newList);
        //AccountHelper.addAccountTeamMembers(newList,null);
    }

    public static void beforeUpdate(List<Account> newList, Map<Id,Account> oldMap){
        //AccountHelper.trackIndustryChange(newList, oldMap);
    }

    public static void afterInsert(List<Account> newList){
        //AccountHelper.createContact(newList);
        //AccountHelper.addAccountTeamMembers(newList,null);
    }
    
     public static void afterDelete(List<Account> accList){
        
    }

    public static void afterUpdate(List<Account> newList, Map<Id,Account> oldMap){
        //AccountHelper.changeOpportunityStageType(newList);
        //AccountHelper.changeContactIndustry(newList, oldMap);
        //AccountHelper.updateContactDescription(newList,oldMap);
        //AccountHelper.addAccountTeamMembers(newList,oldMap);
    }
    
    public static void beforeDelete(List<Account> accList){
        //AccountHelper.preventAccountDeletion(accList);
    }

}