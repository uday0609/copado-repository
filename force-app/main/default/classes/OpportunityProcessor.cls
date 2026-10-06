public class OpportunityProcessor implements Database.Batchable<sObject>,Database.Stateful {
	
    public integer recordCount = 0;
    
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([SELECT Id,Name FROM Opportunity]);
    }
    
    public void execute(Database.BatchableContext bc, List<Opportunity> oppList){
        for(Opportunity opp : oppList){
        	opp.LeadSource = 'Web';
        }
        update oppList;
        recordCount = recordCount + oppList.size();
    }
    
    public void finish(Database.BatchableContext bc){
        System.debug('Total Processed Records '+ recordCount);
    }
}