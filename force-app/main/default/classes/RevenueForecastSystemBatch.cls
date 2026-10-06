public class RevenueForecastSystemBatch implements Database.Batchable<sObject>{
    public Database.QueryLocator start(Database.BatchableContext bc){
       return Database.getQueryLocator([SELECT Id FROM Opportunity WHERE IsClosed = TRUE AND CloseDate <= LAST_N_DAYS : 30]); 
    }
    
    public void execute(Database.BatchableContext bc, List<Opportunity> oppList){
        if(!oppList.isEmpty()){
        	Set<Id> oppId = new Set<Id>();
            for(Opportunity opp : oppList){
               oppId.add(opp.Id); 
            }
            
            if(!oppId.isEmpty()){
                System.enqueueJob(new RevenueForecastSystemQueueable(oppId,0));
            }
        }
    }
    
    public void finish(Database.BatchableContext bc){
        
    }
    
}