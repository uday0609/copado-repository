public class CustomerEngagementScoringQueueable implements Queueable{
    Set<Id> accId = new Set<Id>();
    public CustomerEngagementScoringQueueable(Set<Id> accId){
        this.accId = accId;
    }
    
    public void execute(QueueableContext context){
        List<Account> account = [SELECT Id, Engagement__c,(SELECT Id FROM Cases WHERE Status != 'Closed'),(SELECT Id FROM Opportunities WHERE IsWon = true),(SELECT Id FROM Contacts) FROM Account WHERE Id IN :accId];
        List<Account> accountUpdate = new List<Account>();
        List<Score_History__c> historyScore = new List<Score_History__c>();
        
        for(Account acc : account) {
            Integer openCases = acc.Cases.size();
            Integer wonOpps = acc.Opportunities.size();
            Integer activeContacts = acc.Contacts.size();
            Decimal oldScore = (acc.Engagement__c == null) ? 0 : acc.Engagement__c;
            Decimal newScore = (wonOpps * 10) + (activeContacts * 2) - (openCases * 5);
            newScore = Math.max(0, newScore);
            Boolean shouldUpdate = false;
            if(oldScore == 0 && newScore > 0) {
                shouldUpdate = true;
            } 
            else if(oldScore > 0) {
                Decimal changePercentage = Math.abs(newScore - oldScore) / oldScore;
                if (changePercentage > 0.10) {
                    shouldUpdate = true;
                }
            }
            if(shouldUpdate) {
                acc.Engagement__c = newScore;
                accountUpdate.add(acc);
                historyScore.add(new Score_History__c(Account__c = acc.Id,Old_Score__c = oldScore,New_Score__c = newScore));
            }
        }
        if(!accountUpdate.isEmpty()) {
            update accountUpdate;
        }
        if(!historyScore.isEmpty()) {
            insert historyScore;
        }
    }
}