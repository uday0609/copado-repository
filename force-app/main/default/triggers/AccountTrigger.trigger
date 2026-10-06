trigger AccountTrigger on Account (before insert, before update,before Delete, after insert, after update, after delete) {

    if(Trigger.isBefore){
        
        if(Trigger.isInsert){
           AccountTriggerHandler.beforeInsert(Trigger.new);
        }
        
        if(Trigger.isUpdate){
            AccountTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
        if(Trigger.isDelete){
           AccountTriggerHandler.beforeDelete(Trigger.Old);
        }
    }
    
    if(Trigger.isAfter){
        
        if(Trigger.isInsert){
            AccountTriggerHandler.afterInsert(Trigger.new);
        }
        
        if(Trigger.isUpdate){
           AccountTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        }
        
        if(Trigger.isDelete){
           AccountTriggerHandler.afterDelete(Trigger.old);
        }
    }
}