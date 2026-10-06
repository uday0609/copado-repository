public class OpportunityRevenueCalculateQueueable implements Queueable {

    Set<Id> oppId = new Set<Id>();

    public OpportunityRevenueCalculateQueueable(Set<Id> oppIds){
        this.oppId = oppIds;
    }

    public void execute(QueueableContext qc){
        Set<Id> accId = new Set<Id>();
        List<Opportunity> oppList = [SELECT Id, AccountId, Amount, CloseDate FROM Opportunity WHERE Id IN :oppId];
        
        Map<Id, Decimal> revenueMap = new Map<Id, Decimal>();
        Map<Id, Date> closeDateMap = new Map<Id, Date>();
        
        for(Opportunity opp : oppList){
        	accId.add(opp.AccountId);
        }
        
        Map<Id,Account> accMap = new Map<Id,Account>([SELECT Id,Total_Revenues__c, Last_Closed_Deal_Date__c FROM Account WHERE Id IN :accId]);

        for(Opportunity opp : oppList){
            if(accMap.containsKey(opp.AccountId)){
              accMap.get(opp.AccountId).Total_Revenues__c =(accMap.get(opp.AccountId).Total_Revenues__c != null ? accMap.get(opp.AccountId).Total_Revenues__c : 0) +(opp.Amount != null ? opp.Amount : 0);
                if(accMap.get(opp.AccountId).Last_Closed_Deal_Date__c < opp.CloseDate){
                    accMap.get(opp.AccountId).Last_Closed_Deal_Date__c = opp.CloseDate;
                }
            }
            else{
                accMap.put(opp.AccountId, new Account(Total_Revenues__c = opp.Amount, Last_Closed_Deal_Date__c = opp.CloseDate));
            }
        }
        
        if(!accMap.isEmpty()){
            database.update(accMap.values(),false);
        }
    }
}