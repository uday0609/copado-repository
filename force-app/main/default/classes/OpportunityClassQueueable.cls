global class OpportunityClassQueueable implements Queueable {
	
    List<Opportunity> oppList = new List<Opportunity>();
    Set<Id> oppId = new Set<Id>();
    
    global OpportunityClassQueueable(List<Opportunity> oppList){
        this.oppList = oppList;
    }
    
    global void execute(QueueableContext qc){
       	List<Task> taskList = new List<Task>();
        
        Map<Id,Task> taskMap = new Map<Id,Task>();
        for(Task task : [SELECT Id,WhatId FROM Task WHERE WhatId IN: oppId AND Subject = 'High Value Client Follow-up']){
            taskMap.put(Task.WhatId,task);
        }
        
        for(Opportunity opp : oppList){
            if(!taskMap.containsKey(opp.Id)){
            	 taskList.add(new Task(Subject = 'High Value Client Follow-up',Priority = 'High',Status ='Not Started', WhatId = opp.Id));
            }
        }
        insert taskList;
    }
}