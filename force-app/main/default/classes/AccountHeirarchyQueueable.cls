public class AccountHeirarchyQueueable implements Queueable{
    private Set<Id> accId = new Set<Id>();
    private Integer reputationCount;
    
    public AccountHeirarchyQueueable(Set<Id> accId,Integer reputationCount){
    	this.accId = accId;
        this.reputationCount = reputationCount;
    }
    
    public void execute(QueueableContext qc){
        if(accId.isEmpty())		return;
        
        Map<Id, Account> accMap = new Map<Id, Account>();
        for(Id id : accId){
            accMap.put(id, new Account(Id = id, Total_Revenues__c = 0));
        }

        for(Opportunity opp : [SELECT Amount, AccountId FROM Opportunity WHERE AccountId IN :accId AND StageName = 'Closed Won']){
            if (opp.Amount != null) {
                accMap.get(opp.AccountId).Total_Revenues__c += opp.Amount;
            }
        }
        
        if(reputationCount > 0){
            for(Account childAccount : [SELECT Id,ParentId,Total_Revenues__c FROM Account WHERE ParentId IN: accId]){
                if(childAccount.Total_Revenues__c != null){
                    accMap.get(childAccount.ParentId).Total_Revenues__c += childAccount.Total_Revenues__c;
                }
            }  
        }
        
        if(!accMap.isEmpty()){
            database.update(accMap.values(),false);
        }
        
        Set<Id> parentId = new Set<Id>();
        for(Account acc : [SELECT ParentId FROM Account WHERE Id IN :accId AND ParentId != null]){
            parentId.add(acc.ParentId);
        }
        
        if(!parentId.isEmpty()){
            reputationCount += 1;
            System.enqueueJob(new AccountHeirarchyQueueable(parentId,reputationCount));
        }
    }
}