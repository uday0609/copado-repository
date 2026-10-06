global class LeadCleanUpBatch implements Database.Batchable<sObject>, Database.Stateful {
    
    public integer recordCount = 0;
    public integer totalRecords = 0;
	
     global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([SELECT Id,Status,CreatedDate FROM Lead WHERE Status = 'Open - Not Contacted' AND CreatedDate  <= LAST_N_DAYS:30]);
    }
    
    global void execute(Database.BatchableContext bc, List<Lead> leadList){
        for(Lead lead : leadList){
            lead.Status = 'Closed - Not Converted';
            lead.Inactive__c = TRUE;
        }
    	Database.SaveResult[] results = Database.update(leadList, false);
        for(Database.saveResult sr : results){
            if(!sr.isSuccess()){
                System.debug(sr.getErrors());
            }
            else{
                recordCount+=1;
            }
        }
        totalRecords+=leadList.size();
    }
    
    global void finish(Database.BatchableContext bc){
        System.debug(recordCount + ' Records updated successfully');
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {'udaypunjani06@gmail.com'});
        mail.setSubject('Lead Cleanup Batch Job Result');
        mail.setPlainTextBody(recordCount + ' records updated successfully out of '+ totalRecords +' Records');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
    }
}