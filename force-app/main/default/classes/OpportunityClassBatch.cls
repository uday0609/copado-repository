global class OpportunityClassBatch implements Database.Batchable<sObject> {
	
    global Database.QueryLocator start(Database.BatchableContext bc){
         return Database.getQueryLocator([SELECT Id,StageName,Amount,CloseDate FROM Opportunity WHERE StageName = 'Closed Won' AND Amount > 100000 AND CloseDate = LAST_N_DAYS:7]);
    }
    
    global void execute(Database.BatchableContext bc, List<Opportunity> oppList){
        if(!oppList.isEmpty()){
      		System.enqueueJob(new OpportunityClassQueueable(oppList));    
        }
    }
    
    global void finish(Database.BatchableContext bc){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {'udaypunjani06@gmail.com'});
        mail.setSubject('Opportunity Task Batch Job Result');
        mail.setPlainTextBody('records updated successfully');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
    }
}