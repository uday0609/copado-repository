trigger ContactTrigger on Contact (before insert, before update, before delete,after insert, after update, after delete, after undelete) {
    if(Trigger.isBefore){
        
        if(Trigger.isInsert){
            ContactTriggerHandler.beforeInsert(Trigger.new);
        }
        
        else if(Trigger.isUpdate){
            ContactTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
        
        else if(Trigger.isDelete){
            ContactTriggerHandler.beforeDelete(Trigger.oldMap);
        }
    }
    
    else if(Trigger.isAfter){
        
        if(Trigger.isInsert){
            ContactTriggerHandler.afterInsert(Trigger.new);
        }
        
        else if(Trigger.isUpdate){
            ContactTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        }
        
        else if(Trigger.isDelete){
            ContactTriggerHandler.afterDelete(Trigger.old);
        }
        
        else if(Trigger.isUndelete){
            ContactTriggerHandler.afterUndelete(Trigger.new);
        }
    }
}