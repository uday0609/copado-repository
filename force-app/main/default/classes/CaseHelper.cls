public class CaseHelper {
    
    public static void setCountOnOpportunity(List<Case> caseList,Map<Id,Case>oldMap){
        if(!caseList.isEmpty()){
            Set<Id> oppId = new Set<Id>();
            for(Case cases : caseList){
                if(cases.Opportunity__c != NULL){
                    oppId.add(cases.Opportunity__c);
                }
                if (oldMap != null && oldMap.get(cases.Id).Opportunity__c != null && oldMap.get(cases.Id).Opportunity__c != cases.Opportunity__c) {
                    oppId.add(oldMap.get(cases.Id).Opportunity__c);
                }
            }
            
            List<Opportunity> oppList = [SELECT Id,Total_Cases__c, (SELECT Id FROM Cases__r) FROM Opportunity WHERE Id IN: oppId ];
            for(Opportunity opp: oppList ){
                opp.Total_Cases__c = opp.cases__r.size();
            }
            update oppList;
        }   
    }
    
    // Created by Uday on 16 Mar 2026 for not letting the description field empty when case priority is high
    public static void validateCasePriority(List<Case>caseList){
        for(Case cases : caseList){
            if(cases.Priority == 'High' && cases.Description == null)	cases.Description.addError('If case priority is high description cannot be blank');
        }   
    }
    
    // Created by Uday on 18 Mar 2026 for updating the escalated case count field of account and also send email to the contact representative
    public static void updatingTotalEscalation(List<Case> caseList,Map<Id,Case>oldMap){
        Set<Id> accId = new Set<Id>();
        Set<Id> conId = new Set<Id>();
        for(Case cases : caseList){
            if(cases.Status == 'Escalated' && cases.AccountId != null && (oldMap == null || oldMap.get(cases.Id).Status != 'Escalated')){
                accId.add(cases.AccountId);
            }
            if(cases.Status == 'Escalated' && cases.ContactId != null && (oldMap == null || oldMap.get(cases.Id).Status != 'Escalated')){
                conId.add(cases.ContactId);
            }
            if(oldMap.get(cases.Id).AccountId != cases.AccountId && oldMap.get(cases.Id).AccountId != null){
                accId.add(oldMap.get(cases.Id).AccountId);	
            } 
        }
        
        Map<Id,Account> accMap = new Map<Id,Account>([SELECT Id,Escalated_Cases_Count__c,OwnerId FROM Account WHERE Id IN: accId]);
        for(Id id : accMap.keySet()){
            accMap.get(id).Escalated_Cases_Count__c = 0;   
        }
        
        List<Case> relatedCase = [SELECT Id,AccountId,Status FROM Case WHERE AccountId IN: accMap.keySet() AND Status = 'Escalated'];
        for(Case cases : relatedCase){
            if(accMap.containsKey(cases.AccountId)){
                accMap.get(cases.AccountId).Escalated_Cases_Count__c +=1;
            }
        }
        if(!accMap.isEmpty()){
            List<Account> accList =  accMap.values();
            update accList;
        }
        
        List<Task> taskCreation = new List<Task>();
        for(Case cases : caseList){
            if(accMap.containsKey(cases.AccountId) && cases.Status == 'Escalated'){
           		taskCreation.add(new Task(Subject='New Task for account owner related to case escalation',Status='Not Started',Priority='High',OwnerId=accMap.get(cases.AccountId).OwnerId,WhatId=cases.AccountId));    
            }
        }
        
        if(!taskCreation.isEmpty()){
            insert taskCreation;
        }
        
        List<Contact> relatedContact = [SELECT Id,FirstName,LastName,Email FROM Contact WHERE Id IN: conId];
        List<Messaging.SingleEmailMessage> email = new List<Messaging.SingleEmailMessage>();
        for(Contact con : relatedContact){
            if(con.Email != null){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                List<String> sendingPerson = new List<String>();
                sendingPerson.add(con.Email);
                mail.setToAddresses(sendingPerson);
                mail.setSubject('Update Regarding your case status');
                mail.setPlainTextBody('Hello '+con.FirstName + ' ' + con.LastName + ',\n\nYour Case Status has been updated to the further stage');
				mail.setSenderDisplayName('Salesforce Team');
				email.add(mail);                
            }
        }
        if(!email.isEmpty()){
            Messaging.sendEmail(email);
        }
    }
    
    // Created by Uday on 30 Mar 2026 for checking the case priority if the case priority is high then update the account priority status as High
    public static void checkCasePriority(List<Case> caseList, Map<Id,Case> oldMap){
        Set<Id> accId = new Set<Id>();
        for(Case cases : caseList){
            if(cases.AccountId != null &&(oldMap == null || (oldMap != null && oldMap.get(cases.Id).AccountId != null && (oldMap.get(cases.Id).AccountId != cases.AccountId || oldMap.get(cases.Id).Priority != cases.Priority)))){
                accId.add(cases.AccountId);
            }
            if(oldMap != null && cases.AccountId != null && oldMap.get(cases.Id).AccountId != null && oldMap.get(cases.Id).AccountId != cases.AccountId){
                accId.add(oldMap.get(cases.Id).AccountId);
            }
        }
        
        System.debug('104  acc Set '+accId);
        
        Map<Id,Account> accMap = new Map<Id,Account>([SELECT Id,Account_Priority__c FROM Account WHERE Id IN: accId]);
        System.debug('105    Map '+ accMap);
        List<Case> casesList = [SELECT AccountId,Status,Priority FROM Case WHERE AccountId IN: accId AND Priority = 'High' AND Status != 'Closed'];
    	
        for(Id id : accMap.keySet()){
            accMap.get(id).Account_Priority__c = 'Normal';
        }
        
        for(case cases : casesList){
            if(cases.Priority == 'High'){
                if(accMap.get(cases.AccountId).Account_Priority__c != 'High'){
                    accMap.get(cases.AccountId).Account_Priority__c = 'High';
                }
            }
        }
        
        if(!accMap.isEmpty()){
            database.update(accMap.values(),false);
        }
    }
}