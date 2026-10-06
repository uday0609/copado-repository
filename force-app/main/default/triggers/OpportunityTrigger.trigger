trigger OpportunityTrigger on Opportunity (before insert, before update, before delete, after insert, after update, after delete) {
    if(Trigger.isBefore){
        if(Trigger.isInsert){
           OpportunityTriggerHandler.beforeInsert(Trigger.new);
        }
        
        if(Trigger.isUpdate){
            OpportunityTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
        
        if(Trigger.isDelete){
            OpportunityTriggerHandler.beforeDelete(Trigger.old);
        }
    }
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            OpportunityTriggerHandler.afterInsert(Trigger.new);
        }
        
        if(Trigger.isUpdate){
            OpportunityTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        }
        
        if(Trigger.isDelete){
            OpportunityTriggerHandler.afterDelete(Trigger.old);
        }
    }
}