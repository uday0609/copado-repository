public class RevenueForecastSystemQueueable implements Queueable{
    private Set<Id> oppId = new Set<Id>();
    private Integer retryCount;
    
    public RevenueForecastSystemQueueable(Set<Id> oppId,Integer retryCount){
        this.oppId = oppId;
        this.retryCount = retryCount;
    }
    
    public void execute(QueueableContext qc){
        Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>([SELECT Id,Forecast_Amount__c, Forecast_Status__c FROM Opportunity WHERE Id IN: oppId]);
        List<OpportunityLineItem> oppProductList = [SELECT Id,TotalPrice,OpportunityId FROM OpportunityLineItem WHERE OpportunityId IN: oppId];
        
        for(Id id : oppMap.keySet()){
        	oppMap.get(id).Forecast_Amount__c = 0;
            oppMap.get(id).Forecast_Status__c = 'Pending';
        }
        
        for(OpportunityLineItem oppProduct : oppProductList){
            if(oppMap.containsKey(oppProduct.OpportunityId)){
                oppMap.get(oppProduct.OpportunityId).Forecast_Amount__c = (oppMap.get(oppProduct.OpportunityId).Forecast_Amount__c != null ? oppMap.get(oppProduct.OpportunityId).Forecast_Amount__c : 0) +(oppProduct.TotalPrice != null ? oppProduct.TotalPrice : 0);
                oppMap.get(oppProduct.OpportunityId).Forecast_Status__c = 'Completed';
            }
        }
        
        for(Id id : oppMap.keySet()){
            oppMap.get(id).Forecast_Amount__c = oppMap.get(id).Forecast_Amount__c + oppMap.get(id).Forecast_Amount__c * 0.10;
        }
        
        List<Opportunity> oppList = oppMap.values();
        Database.SaveResult[] results = Database.update(oppList, false);
        Set<Id> failedId = new Set<Id>();
        for(Integer i=0; i < results.size(); i++) {
            if(!results[i].isSuccess()) {
                failedId.add(oppList[i].Id);
            }
        }
        
        if (!failedId.isEmpty() && retryCount<2) {
            if(!Test.isRunningTest()){
                System.enqueueJob(new RevenueForecastSystemQueueable(failedId,retryCount+1));
            }
        } 
        else if(!failedId.isEmpty() && retryCount>=2) {
            List<Opportunity> failedOpps = [SELECT Id FROM Opportunity WHERE Id IN :failedId];
            for(Opportunity opp : failedOpps) opp.Forecast_Status__c = 'Failed';
            update failedOpps;
        }
    }
}