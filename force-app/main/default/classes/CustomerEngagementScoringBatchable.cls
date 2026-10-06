public class CustomerEngagementScoringBatchable implements Database.Batchable<sObject>{
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([SELECT Id FROM Account]);
    }
    
    public void execute(Database.BatchableContext bc, List<Account> accList){
        if(!accList.isEmpty()){
            Set<Id> accId = new Set<Id>();
            for(Account acc : accList){
                accId.add(acc.Id);
            } 
            
            if(!accId.isEmpty()){
                System.enqueueJob(new CustomerEngagementScoringQueueable(accId));
            }
        }
    }
    
    public void finish(Database.BatchableContext bc){
        
    }
}