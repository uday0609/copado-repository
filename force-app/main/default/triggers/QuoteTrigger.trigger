trigger QuoteTrigger on Quote (before insert,before update) {
    if(trigger.isBefore){
        if(trigger.isInsert){
            QuoteTriggerHandler.changeSalesTaxLookup(Trigger.new, null);
        }
        else if(trigger.isUpdate){
            QuoteTriggerHandler.changeSalesTaxLookup(Trigger.new, trigger.oldMap);
        }
    }
}