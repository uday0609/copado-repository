public class InactiveCustomerCleanupBatch implements Database.Batchable<SObject>,Database.Stateful{
    
    private Integer totalAccountProcessed = 0;
    private Integer totalTasksCreated = 0;
    
    Id batchDataId;
    
    public InactiveCustomerCleanupBatch(Id batchDataId){
        this.batchDataId = batchDataId;
    }
    
    public Database.QueryLocator start(Database.BatchableContext bc){
        try{
            if(batchDataId == null){
                Batch_Summary__c batchData = new Batch_Summary__c(Job_Name__c = 'Inactive Customer Clean Up Batch',Batch_Run_Date__c = System.today(),Status__c = 'Started');
                insert batchData;
                batchDataId = batchData.Id;
            }
            
            return Database.getQueryLocator([SELECT Id,Status__c,Inactive_Since__c FROM Account WHERE Type = 'Customer' AND Id NOT IN (SELECT AccountId FROM Opportunity WHERE CloseDate >= LAST_N_YEARS:1)]); 
        }
        
        catch(QueryException e){
            System.debug('Error in returning records'+ e.getMessage());
            return null;
        }
        
    }
    
    public void execute(Database.BatchableContext bc, List<Account> accList){
        try{
            if(!accList.isEmpty()){
                Set<Id> accId = new Set<Id>();
                for(Account acc : accList){
                    accId.add(acc.Id);
                }
                
                List<Task> taskList = new List<Task>();
                Map<Id,Task> taskMap = new Map<Id,Task>([SELECT WhatId,Subject FROM Task WHERE WhatId IN: accId AND Subject = 'Re-engage Customer']);
                for(Account acc : accList){
                    acc.Status__c = 'Inactive';
                    acc.Inactive_Since__c = System.TODAY();
                    
                    if(!taskMap.containsKey(acc.Id)){
                        taskList.add(new Task(Subject = 'Re-engage Customer', Priority = 'High', WhatId = acc.Id)); 
                    }
                }
                
                database.update(accList,false);
                
                if(!taskList.isEmpty()){
                    totalTasksCreated += taskList.size();
                    Database.insert(taskList,false);
                }
                
                totalAccountProcessed += accList.size();
            }
        }
        
        catch(Exception e){
            System.debug('Error in records' + e.getMessage());
        }
    }
    
    public void finish(Database.BatchableContext bc){
        try{
            Batch_Summary__c batchData = [SELECT Id FROM Batch_Summary__c WHERE Id = :batchDataId LIMIT 1]; 
            batchData.Status__c = 'Completed';
            batchData.Total_Account_Processed__c = totalAccountProcessed;
            batchData.Total_Task_Created__c = totalTasksCreated;
            update batchData;
        }
        catch(Exception e){
            System.debug('Exception in finish: ' + e.getMessage());
        }
    }
}