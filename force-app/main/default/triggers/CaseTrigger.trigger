trigger CaseTrigger on Case (after insert, after update, before insert, before update, after delete, after undelete) {
    
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            CaseTriggerHandler.beforeInsert(Trigger.new);
        }
        if(Trigger.isUpdate){
        	CaseTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
    }
    
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUnDelete)){
        CaseHelper.setCountOnOpportunity(Trigger.new,NULL);
    }
    
    else if(Trigger.isAfter && Trigger.isDelete){
        //CaseHelper.setCountOnOpportunity(Trigger.old,NULL);
        CaseTriggerHandler.afterDelete(Trigger.old);
    }
    	
    else if(Trigger.isUpdate){
        CaseTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
		 //CaseHelper.setCountOnOpportunity(Trigger.new,Trigger.oldMap);      
    }
}