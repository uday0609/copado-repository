trigger TaskTrigger on Task (before insert,before update) {
    if(trigger.isBefore){
        if(trigger.isInsert){
            TaskTriggerHandler.changeDueDate(trigger.new,null);
        }
        else if(trigger.isUpdate){
        	TaskTriggerHandler.changeDueDate(trigger.new,trigger.oldMap);
        }
    }
}