public class AccountMonthlyBatch implements Database.Batchable<sObject>, Database.Stateful {
    
    private Integer totalAccountsUpdated = 0;
    private Integer totalTasksCreated = 0;
    
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([SELECT Id,LastModifiedDate,OwnerId FROM Account WHERE LastModifiedDate < LAST_N_DAYS:30]);
    }
    
    public void execute(Database.BatchableContext bc, List<Account> accList){
        //System.debug('11   AccList'+accList);
        if(!accList.isEmpty()){
            Map<Id,Account> accMap = new Map<Id,Account>();
            for(Account acc : accList){
                accMap.put(acc.Id, acc);
                acc.Maintenance_Status__c = 'Pending Review';
            }
            Database.SaveResult[] results = Database.update(accList, false);
            for(Database.saveResult sr : results){
                if(!sr.isSuccess()){
                    System.debug(sr.getErrors());
                }
                else{
                    totalAccountsUpdated += 1;
                }
            }
            
            List<Opportunity> relatedOpp= new List<Opportunity>([SELECT Id,Name,AccountId,StageName FROM Opportunity WHERE AccountId IN: accMap.keySet() AND StageName = 'Closed Lost' ]);
            List<Task> taskList = new List<Task>();
            for(Opportunity opp : relatedOpp){
                taskList.add(new Task(Subject='Review Lost Opportunity ' + opp.Name , Status='Not Started' , Priority='High', OwnerId=accMap.get(opp.AccountId).OwnerId,WhatId=opp.AccountId)); 
            }
            
            if(!taskList.isEmpty()){
                Database.SaveResult[] result = Database.insert(taskList, false);
                for(Database.saveResult sr : result){
                    if(!sr.isSuccess()){
                        System.debug(sr.getErrors());
                    }
                    else{
                        totalTasksCreated += 1;
                    }
                } 
            }
        }
    }
    
    public void finish(Database.BatchableContext bc){
        User SystemAdmin = 	[SELECT Id,Email FROM User WHERE Profile.Name = 'System Administrator'AND IsActive = TRUE AND UserRole.Name = 'CEO' LIMIT 1 ];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        if(SystemAdmin != null)	  mail.setToAddresses(new String[] {SystemAdmin.Email});
        mail.setSubject('Account Monthly Batch Job Processing Result');
        mail.setPlainTextBody(totalAccountsUpdated + ' records of account updated\n' + totalTasksCreated + ' records of task created successfully');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
    }
}