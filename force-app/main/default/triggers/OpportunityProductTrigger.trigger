trigger OpportunityProductTrigger on OpportunityProduct__c (before insert, before update) {
    if(trigger.isBefore){
        if(trigger.isInsert){
            OpportunityProductHandler.checkPrimaryProduct(Trigger.new,null);
        }
        else if(trigger.isUpdate){
            OpportunityProductHandler.checkPrimaryProduct(Trigger.new, Trigger.oldMap);
        }
    }	
}