public class OpportunityHelper {
    
    // Created by Uday on 3 Mar 2026 for account and contact description when opportunity amount is changed
    public static void updateDescription(List<Opportunity> newList, Map<Id, Opportunity> oldMap) {
        Set<Id> accountIds = new Set<Id>();
        Set<Id> contactIds = new Set<Id>();
        List<Opportunity> opportunitiesToProcess = new List<Opportunity>();
        
        for (Opportunity opp : newList) {
            if (opp.Amount != oldMap.get(opp.Id).Amount) {
                opportunitiesToProcess.add(opp);
                if (opp.AccountId != null) {
                    accountIds.add(opp.AccountId);
                }
                if (opp.ContactId != null) {
                    contactIds.add(opp.ContactId);
                }
            }
        }
        
        if (opportunitiesToProcess.isEmpty()) return;
        
        Map<Id, Account> accountsToUpdate = new Map<Id, Account>([SELECT Id, Description FROM Account WHERE Id IN :accountIds]);
        Map<Id, Contact> contactsToUpdate = new Map<Id, Contact>([SELECT Id, Description FROM Contact WHERE Id IN :contactIds]);
        
        for (Opportunity opp : opportunitiesToProcess) {
            String newDescription = 'Old Amount is : ' + oldMap.get(opp.Id).Amount + ' New Amount is : ' + opp.Amount;
            if (opp.AccountId != null && accountsToUpdate.containsKey(opp.AccountId)) {
                accountsToUpdate.get(opp.AccountId).Description = newDescription;
            } 
            if (opp.ContactId != null && contactsToUpdate.containsKey(opp.ContactId)) {
                contactsToUpdate.get(opp.ContactId).Description = newDescription;
            }
        }
        
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate.values(); 
        }        
        if (!contactsToUpdate.isEmpty()) {
            update contactsToUpdate.values();
        }
    }
    
    
    // Created by Uday on 04 March for auto fill of opportunity stage type when newly created on the basis of related account type
    public static void updateStageType(List<Opportunity>oppList){
        for(Opportunity opp : oppList ){
            List<Account> accList = [SELECT Id,Account_Type__c FROM Account where Id = : opp.AccountId ];
            for(Account acc: accList)
                if(acc.Account_Type__c == null){
                    opp.Stage_Type__c = '0';
                }
            else if(acc.Account_Type__c == 'Reseller'){
                opp.Stage_Type__c = '10';
            }
            else if(acc.Account_Type__c == 'Buyer'){
                opp.Stage_Type__c = '25';
            }
            else if(acc.Account_Type__c == 'Current Customer'){
                opp.Stage_Type__c = '100';
            }
        }
    }
    
    
    // Extra Questions practice on trigger
    
    // Created by Uday on 5 March 2026 for updating the parent account description with the highest and lowest amount opportunity after every new insert
    public static void findHighestAndLowestSalaryOfOpportunity(List<Opportunity>oppList){
        Set<Id> accSet = new Set<Id>();
        
        for(Opportunity opp : oppList){
            if(OpportunityTriggerHandler.visitedOpportunity.contains(opp.AccountId))   continue;
            if(opp.AccountId != null && opp.Amount != null){
                accSet.add(opp.AccountId);  
            }
            OpportunityTriggerHandler.visitedOpportunity.add(opp.AccountId);
        }
        
        if(accSet.isEmpty()) return;
        
        List<Account> accList = new List<Account>();
        
        for(AggregateResult ar: [SELECT AccountId,MAX(Amount)Maximum,MIN(Amount) Minimum FROM Opportunity WHERE AccountId IN : accSet GROUP BY AccountId]){
            accList.add(new Account(Id = (Id)ar.get('AccountId'), Description = 'Lowest Amount is : ' + (Decimal)ar.get('Minimum') +' Highest Amount is : ' + (Decimal)ar.get('Maximum')));
        }
        
        if(accList.size()>0){
            update accList;
        }
    }
    
    // Created by Uday on 5 March 2026 for updating the parent account description with the highest and lowest amount opportunity after every new update
    public static void findHighestAndLowestSalaryOfOpportunityOnUpdate(List<Opportunity>oppList,Map<Id,Opportunity>oldMap){
        Set<Id> accSet = new Set<Id>();
        
        for(Opportunity opp : oppList){
            if(OpportunityTriggerHandler.visitedOpportunity.contains(opp.AccountId))   continue;
            if(opp.AccountId != null && opp.Amount != oldMap.get(opp.Id).Amount && opp.Amount != null){
                accSet.add(opp.AccountId);  
            }
            OpportunityTriggerHandler.visitedOpportunity.add(opp.AccountId);
        }
        
        if(accSet.isEmpty()) return;
        
        List<Account> accList = new List<Account>();
        
        for(AggregateResult ar: [SELECT AccountId,MAX(Amount)Maximum,MIN(Amount) Minimum FROM Opportunity WHERE AccountId IN : accSet GROUP BY AccountId]){
            accList.add(new Account(Id = (Id)ar.get('AccountId'), Description = 'Lowest Amount is : ' + (Decimal)ar.get('Minimum') +' Highest Amount is : ' + (Decimal)ar.get('Maximum')));
        }
        
        if(accList.size()>0){
            update accList;
        }
        
    }
    
    //Created by Uday on 5 March 2026 for updating the parent account description with the highest and lowest amount opportunity after every new update
    public static void findHighestAndLowestSalaryOfOpportunityOnDelete(Map<Id,Opportunity>oldMap){
        Set<Id> accSet = new Set<Id>();
        
        for(Id id : oldMap.keySet()){
            if(OpportunityTriggerHandler.visitedOpportunity.contains(oldMap.get(id).AccountId))   continue;
            if(oldMap.get(id).AccountId != null && oldMap.get(id).Amount != null){
                accSet.add(oldMap.get(id).AccountId);  
            }
            OpportunityTriggerHandler.visitedOpportunity.add(oldMap.get(id).AccountId);
        }
        
        if(accSet.isEmpty()) return;
        List<Account> accList = new List<Account>(); 
        for(AggregateResult ar: [SELECT AccountId,MAX(Amount)Maximum,MIN(Amount) Minimum FROM Opportunity WHERE AccountId IN : accSet GROUP BY AccountId]){
            accList.add(new Account(Id = (Id)ar.get('AccountId'), Description = 'Lowest Amount is : ' + (Decimal)ar.get('Minimum') +' Highest Amount is : ' + (Decimal)ar.get('Maximum')));
        }
        if(accList.size()>0){
            update accList;
        }
        
    }
    
    // Created by Uday on 7 Mar 2026 for creating the task for that opportunity when the opportunity amount is more than 50000
    public static void createTaskOnOpportunity(List<Opportunity>oppList){
        List<Task> taskList = new List<Task>();
        
        for(Opportunity opp : oppList){
            if(opp.Amount > 50000) taskList.add(new Task(Subject ='New Task for above 50000 opportunity ', Status = 'Not Started', Priority= 'Normal', WhatId = opp.Id, Description =''));
        }
        
        insert taskList;
    }
    
    // Created by Uday on 11 Mar 2026 for updating the total revenue of the account when the opportunity is closed won
    public static void updateAccountTotalRevenue(List<Opportunity> oppList, Map<Id,Opportunity> oldMap){
        Set<Id> accountId = new Set<Id>();
        for (Opportunity opp : oppList) {
            Opportunity oldOpp = (oldMap != null) ? oldMap.get(opp.Id) : null;
            if (opp.AccountId != null) {
                if (oldOpp == null || opp.StageName != oldOpp.StageName || opp.AccountId != oldOpp.AccountId) {
                    accountId.add(opp.AccountId);
                }
            }
            if (oldOpp != null && oldOpp.AccountId != null && opp.AccountId != oldOpp.AccountId) {
                accountId.add(oldOpp.AccountId);
            }
        }
        
        List<Opportunity> opportunityList = [SELECT Id,AccountId,StageName,Amount FROM Opportunity WHERE AccountId IN: accountId AND StageName = 'Closed Won'];
        Map<Id,Account> accountMap = new Map<Id,Account>();
        
        for(Opportunity opp : opportunityList){
            if(!accountMap.containsKey(opp.AccountId)){
                accountMap.put(opp.AccountId,new Account(Id = opp.AccountId, Total_Revenues__c = 0));
            }  
            Account acc = accountMap.get(opp.AccountId);
            acc.Total_Revenues__c += opp.Amount != null ? opp.Amount : 0;
        }
        
        if(!accountMap.isEmpty()){
            List<Account> accountUpdate = accountMap.values();
            if(!accountUpdate.isEmpty())  update accountUpdate;
        }
    }
    
    // Created by Uday on 12 Mar 2026 for preventing opportunity closed won when the contact role not excists
    public static void preventClosingOpportunity(List<Opportunity> oppList,Map<Id,Opportunity> oldMap){
        Set<Id> oppId = new Set<Id>();
        for(Opportunity opp: oppList){
            if(opp.StageName == 'Closed Won' && opp.StageName != oldMap.get(opp.Id).StageName){
                oppId.add(opp.Id);   
            }
        }
        
        Set<Id> RelatedOppContactId = new Set<Id>();
        for(OpportunityContactRole oppContact : [SELECT OpportunityId FROM OpportunityContactRole WHERE OpportunityId IN : oppId]){
            RelatedOppContactId.add(oppContact.OpportunityId);
        }
        
        for(Opportunity opp : oppList){
            if(opp.StageName == 'Closed Won' && (opp.ContactId == null ||!RelatedOppContactId.contains(opp.Id)))  opp.addError('Opportunity cannot be closed without a contact role.'); 
        }
    }
    
    // Created by Uday on 13 Mar 2026 for maintaining opportunity stage history whenever any opportunity stage is changed
    public static void maintainOpportunityStageHistory(List<Opportunity> oppList, Map<Id,Opportunity> oldMap){
        List<Opportunity_Stage_History__c> oppStageHistory = new List<Opportunity_Stage_History__c>();
        for(Opportunity opp: oppList){
            if(opp.Id != null && opp.StageName != oldMap.get(opp.Id).StageName){
                oppStageHistory.add(new Opportunity_Stage_History__c(Opportunity__c = opp.Id, Old_Stage__c = oldMap.get(opp.Id).StageName, New_Stage__c = opp.StageName, Changed_Date__c = System.Today()));				
            }
        }
        insert oppStageHistory;
    }
    
    // Created by Uday on 13 Mar 2026 for restricting further stage progression of the related opportunities
    public static void restrictAccountStageProgress(List<Opportunity> oppList,Map<Id,Opportunity>oldMap){
        Set<Id> accountId = new Set<Id>();
        for (Opportunity opp : oppList) {
            Opportunity oldOpp = (oldMap != null) ? oldMap.get(opp.Id) : null;
            if (opp.AccountId != null) {
                if (oldOpp == null || opp.StageName != oldOpp.StageName || opp.AccountId != oldOpp.AccountId) {
                    accountId.add(opp.AccountId);
                }
            }
            if (oldOpp != null && oldOpp.AccountId != null && opp.AccountId != oldOpp.AccountId) {
                accountId.add(oldOpp.AccountId);
            }
        }
        
        List<Opportunity> opportunityList = [SELECT Id,AccountId,StageName,Amount,High_Risk__c FROM Opportunity WHERE AccountId IN: accountId AND StageName != 'Closed Won' AND StageName != 'Closed Lost'];
        Map<Id,Account> accountMap = new Map<Id,Account>([SELECT Id,Total_Revenues__c, Total_Limit__c FROM Account WHERE Id IN: accountId]);
        Map<String,Integer> stageMap = new Map<String, Integer>{'Prospecting' => 1, 'Qualification' => 2, 'Needs Analysis' => 3, 'Value Proposition' => 4, 'Decision Makers' => 5, 'Perception Analysis' => 6,' Proposal/Price Quote' => 7, 'Negotiation/Review' => 8, 'Closed Won' => 9,  'Closed Lost' =>  9};    
            for(Id id : accountMap.keySet()){
                accountMap.get(id).Total_Revenues__c = 0;
            }
        
        for(Opportunity opp : opportunityList){
            Account acc = accountMap.get(opp.AccountId);
            acc.Total_Revenues__c += opp.Amount != null ? opp.Amount : 0;
        }
        
        if(!accountMap.isEmpty()){
            List<Account> accList = accountMap.values();
            update accList;
        }
        
        for(Opportunity opp : opportunityList){
            if(accountMap.get(opp.AccountId).Total_Revenues__c > accountMap.get(opp.AccountId).Total_Limit__c)
                opp.High_Risk__c = TRUE;
            else 
                opp.High_Risk__c = FALSE;
        }
        update opportunityList;
        
        for(Opportunity opp : oppList){
            if(oldMap != null){
                if(opp.High_Risk__c == TRUE && stageMap.get(oldMap.get(opp.Id).StageName) < stageMap.get(opp.StageName)){
                    opp.addError('Opportunity Stage cannot be changed due to high risk');
                }
            }
        }
    }
    
    // Created by Uday on 13 Mar 2026 for preventing change in opportunity fields when it is closed won
    public static void preventChangingOpportunity(List<Opportunity> oppList, Map<Id, Opportunity> oldMap) {
        if(oppList == null || oldMap == null){
            return;
        }
        for(Opportunity opp :oppList){
            if(opp == null || !oldMap.containsKey(opp.Id)){
                continue;
            }
            if(oldMap.get(opp.Id).StageName == 'Closed Won'){
                if(oldMap.get(opp.Id).Amount != opp.Amount||oldMap.get(opp.Id).CloseDate != opp.CloseDate|| oldMap.get(opp.Id).AccountId != opp.AccountId ){
                    opp.addError('Amount, Close Date and Account cannot be modified once Opportunity is Closed Won.');
                }
            }
        }
    }
    
    // Created by Uday on 14 Mar 2026 for preventing duplicate opportunity to insert when the account, closeDate and stage is same
    public static void preventDuplicateOpportunity(List<Opportunity> oppList){
        if(oppList == null){
            return;
        }
        Set<Id> accountIds = new Set<Id>();
        Set<Date> closeDates = new Set<Date>();
        Set<String> stages = new Set<String>();
        for(Opportunity opp : oppList){
            if(opp.AccountId != null) accountIds.add(opp.AccountId);
            if(opp.CloseDate != null) closeDates.add(opp.CloseDate);
            if(opp.StageName != null) stages.add(opp.StageName);
        }
        
        Set<String> existingKeys = new Set<String>();
        for(Opportunity opp : [SELECT AccountId, CloseDate, StageName FROM Opportunity WHERE AccountId IN :accountIds AND CloseDate IN :closeDates AND StageName IN :stages]){
            String key = opp.AccountId + '-' + opp.CloseDate + '-' + opp.StageName;
            existingKeys.add(key);
        }
        
        Set<String> currentKeys = new Set<String>();
        for(Opportunity opp : oppList){
            String key = opp.AccountId + '-' + opp.CloseDate + '-' + opp.StageName;
            if(existingKeys.contains(key)){
                opp.addError('Duplicate Opportunity already exists for this Account, Close Date and Stage.');
                continue;
            }
            if(currentKeys.contains(key)){
                opp.addError('Duplicate Opportunity detected in the same transaction.');
                continue;
            }
            currentKeys.add(key);
        }
    }
    
    // Created by Uday on 16 Mar 2026 to prevent Opportunity deletion when it is closed won with the error message
    public static void preventOpportunityDeletion(List<Opportunity> oppList){
        Set<Id> oppId = new Set<Id>();
        for(Opportunity opp : oppList){
            if(opp.Id != null && opp.StageName =='Closed Won')	oppId.add(opp.Id);
        }
        
        for(Opportunity opp : oppList){
            if(oppId.contains(opp.Id))	opp.addError('Closed Won Opportunities cannot be deleted');
        }
    }
    
    // Created by Uday on 16 Mar 2026 for the opportunity with the same email and if found with same email then delete or prevent the lower stage opportunity
    public static void preventOrDeleteLowStageOpportunity(List<Opportunity> oppList){
        Set<Id> accId = new Set<Id>();
        Set<String> accEmail = new Set<String>();
        for(Opportunity opp : oppList){
            if(opp.AccountId != null ){
                accId.add(opp.AccountId);
            }
            if(opp.Email__c != null ){
                accEmail.add(opp.Email__c);
            }
        }
        
        Set<String> currentRecords = new Set<String>();
        Map<String,Opportunity> oppMap = new Map<String,Opportunity>();
        Map<String,Integer> stageMap = new Map<String, Integer>{'Prospecting' => 1, 'Qualification' => 2, 'Needs Analysis' => 3, 'Value Proposition' => 4, 'Decision Makers' => 5, 'Perception Analysis' => 6,' Proposal/Price Quote' => 7, 'Negotiation/Review' => 8, 'Closed Won' => 9,  'Closed Lost' =>  9};
            for(Opportunity oppor : [SELECT AccountId,Id,Email__c,StageName FROM Opportunity WHERE AccountId IN: accId AND Email__c IN: accEmail]){
                String key = oppor.AccountId + ' | ' + oppor.Email__c;
                if(!oppMap.containsKey(key)){
                    oppMap.put(key,oppor);
                }
            }
        
        List<Opportunity> opportunityDelete = new List<Opportunity>();
        for(Opportunity opp: oppList){
            if(oppMap.containsKey(opp.AccountId + ' | ' + opp.Email__c)){
                if(stageMap.get(opp.StageName) >= stageMap.get(oppMap.get(opp.AccountId + ' | ' + opp.Email__c).StageName)){
                    opportunityDelete.add(oppMap.get(opp.AccountId + ' | ' + opp.Email__c));
                }
                else if(stageMap.get(opp.StageName) < stageMap.get(oppMap.get(opp.AccountId + ' | ' + opp.Email__c).StageName)){
                    opp.addError('Opportunity cannot be inserted or updated as current opportunity with the same email already excists');
                }
                else if(currentRecords.contains(opp.AccountId + ' | ' + opp.Email__c)){
                    opp.addError('The record with the same account and email already occured in this set');
                }
                currentRecords.add(opp.AccountId + ' | ' + opp.Email__c);
            }
        }
        if(!opportunityDelete.isEmpty()){
            delete opportunityDelete;
        }
    }
    
    // Created by Uday on 18 Mar 2026 for splitting the opportunity if the opportunity amount is greater than 100000
    public static void splitOpportunity(List<Opportunity> oppList,Map<Id,Opportunity> oldMap){
        Map<Id,Decimal> parentMap = new Map<Id,Decimal>();
        List<Opportunity> childOpportunities = new List<Opportunity>();
        
        for(Opportunity opp: oppList){
            if(OpportunityTriggerHandler.visitedOpportunity.contains(opp.Id))	continue;
            
            if(oldMap == null && opp.Amount != null && opp.Amount > 100000){
                OpportunityTriggerHandler.visitedOpportunity.add(opp.Id);
                childOpportunities.add(new Opportunity(Name = 'Child Opportunity of ' + opp.Name ,Parent_Opportunity__c = opp.Id,Amount = opp.Amount/2 , CloseDate = opp.CloseDate , StageName = opp.StageName));
                childOpportunities.add(new Opportunity(Name = 'Child Opportunity of ' + opp.Name ,Parent_Opportunity__c = opp.Id ,Amount = opp.Amount/2 , CloseDate = opp.CloseDate , StageName = opp.StageName));
            }
            else if(oldMap != null){
                if(oldMap.get(opp.Id).Amount <= 100000 && opp.Amount > 100000){
                    OpportunityTriggerHandler.visitedOpportunity.add(opp.Id);
                    childOpportunities.add(new Opportunity(Name = 'Child Opportunity of ' + opp.Name ,Parent_Opportunity__c = opp.Id, Amount = opp.Amount/2 , CloseDate = opp.CloseDate , StageName = opp.StageName));
                    childOpportunities.add(new Opportunity(Name = 'Child Opportunity of ' + opp.Name ,Parent_Opportunity__c = opp.Id ,Amount = opp.Amount/2 , CloseDate = opp.CloseDate , StageName = opp.StageName));
                }
                else if(oldMap.get(opp.Id).Amount != opp.Amount){
                    parentMap.put(opp.Id,opp.Amount);
                }
            }
        }
        if(!childOpportunities.isEmpty()) insert childOpportunities;
        if(!parentMap.isEmpty()){
            List<Opportunity> relatedChildOpportunity = [SELECT Id, Parent_Opportunity__c, Amount FROM Opportunity WHERE Parent_Opportunity__c IN: parentMap.keySet()];
            List<Opportunity> toUpdate = new List<Opportunity>();
            List<Opportunity> toDelete = new List<Opportunity>();
            if(!relatedChildOpportunity.isEmpty()){
                for(Opportunity opp : relatedChildOpportunity){
                    if(parentMap.get(opp.Parent_Opportunity__c) > 100000){
                        toUpdate.add(new Opportunity(Id = opp.Id, Amount = parentMap.get(opp.Parent_Opportunity__c)/2));
                    }
                    else if(parentMap.get(opp.Parent_Opportunity__c) <= 100000){
                        toDelete.add(new Opportunity(Id = opp.Id));
                    }
                }
            }
            if(!toUpdate.isEmpty()){
                update toUpdate;
            }
            if(!toDelete.isEmpty()){
                delete toDelete;
            }
        }
    }
    
    // Created by Uday on 19 Mar 2026 for preventing opportunity stage downgrade 
    public static void preventOpportunityDowngrade(List<Opportunity> oppList, Map<Id,Opportunity> oldMap){
        if(oppList != null && oldMap != null){
            Map<String,Integer> stageMap = new Map<String, Integer>{'Prospecting' => 1, 'Qualification' => 2, 'Needs Analysis' => 3, 'Value Proposition' => 4, 'Decision Makers' => 5, 'Perception Analysis' => 6,' Proposal/Price Quote' => 7, 'Negotiation/Review' => 8, 'Closed Won' => 9,  'Closed Lost' =>  9};    
                for(Opportunity opp : oppList){
                    if(opp.StageName != null && oldMap.get(opp.Id).StageName != null && stageMap.get(oldMap.get(opp.Id).StageName) > stageMap.get(opp.StageName)){
                        opp.StageName.addError('Opportunity stage cannot be pushed backward');
                    }
                }       
        }
    }
    
    // Created by Uday on 19 Mar 2026 to update account last deal date field and also create invoice record and also create task for financial team and send email to customer
    public static void createInvoiceTask(List<Opportunity> oppList, Map<Id,Opportunity> oldMap){
        if(!oppList.isEmpty()){
            Set<Id>accSet = new Set<Id>();
            for(Opportunity opp: oppList){
                if(opp.AccountId != null && opp.StageName == 'Closed Won' && (oldMap == null || opp.StageName != oldMap.get(opp.Id).stageName)){
                    accSet.add(opp.AccountId);
                }
                if(oldMap != null && opp.AccountId != oldMap.get(opp.Id).AccountId){
                    accSet.add(oldMap.get(opp.Id).AccountId);
                }
            }
            
            Map<Id,Account> relatedAccount =new Map<Id,Account>([SELECT Id,Last_Deal_Date__c FROM Account WHERE Id IN: accSet]);
            for(Opportunity opp: oppList){
                if(relatedAccount.containsKey(opp.AccountId)){
                    Account acc = relatedAccount.get(opp.AccountId);
                    acc.Last_Deal_Date__c = System.Today();
                }
            }
            
            List<Invoice> invoiceList = new List<Invoice>();
            for(Opportunity opp : oppList){
                if(relatedAccount.containsKey(opp.AccountId)){
                    //invoiceList.add(new Invoice(BillingAccountId = opp.AccountId,Balance = opp.Amount));
                }
            }
        }
    } 
    
    // Created on 30 Mar 2026 by Uday for updating the revenue rollup of account heirarchy 
    public static void calculateRevenueRollup(List<Opportunity> oppList, Map<Id,Opportunity> oldMap){
        if(!oppList.isEmpty()){
            Set<Id> accId = new Set<Id>();
            for(Opportunity opp : oppList){
                if(opp.AccountId != null && (oldMap == null || (oldMap != null && oldMap.get(opp.Id).AccountId != null && (oldMap.get(opp.Id).AccountId != opp.AccountId || oldMap.get(opp.Id).StageName != opp.StageName)))){
                    accId.add(opp.AccountId);
                }
                if(opp.AccountId != null && oldMap != null && oldMap.get(opp.Id).AccountId != null && oldMap.get(opp.Id).AccountId != opp.AccountId){
                    accId.add(oldMap.get(opp.Id).AccountId);
                }
            }
            if(!accId.isEmpty()){
                System.enqueueJob(new AccountHeirarchyQueueable(accId,0));
            }
        }
    }
    
    // Created on 31 Mar 2026 for using the metadata values to check and give the discount accordingly
    public static void getDiscountPercentForDifferentRoles(List<Opportunity> oppList){
        Map<String,Validation_Threshold__mdt> data = Validation_Threshold__mdt.getAll();
        Set<Id> ownerId = new Set<Id>();
        for(Opportunity opp : oppList){
            ownerId.add(opp.OwnerId);
        }
        
        Map<Id,User> userWithRoles = new Map<Id,User>([SELECT Id, UserRole.Name FROM User WHERE Id IN : ownerId]);
        for(Opportunity opp : oppList){
            if(data.containsKey(userWithRoles.get(opp.OwnerId).UserRole.Name + '_Limit')){
                Decimal allowedDiscount = data.get(userWithRoles.get(opp.OwnerId).UserRole.Name + '_Limit').Discount__c;
                if(opp.Discount__c > allowedDiscount){
                    opp.addError('Discount exceeds allowed limit for this role.');
                }
            }
        }
    }
    
    // Created by Uday on 1 Apr 2026 for calculating revenue of the account
    public static void opportunityRevenueRecalculate(List<Opportunity> oppList, Map<Id,Opportunity> oldMap){
       Set<Id> oppId = new Set<Id>();
        for (Opportunity opp : oppList) {
            Opportunity oldOpp = (oldMap != null) ? oldMap.get(opp.Id) : null;
            if (opp.AccountId != null && opp.Amount > 100000 && opp.StageName == 'Closed Won'){
                if (oldOpp == null || opp.StageName != oldOpp.StageName || opp.Amount != oldOpp.Amount) {
                   oppId.add(opp.Id);
                }
            }
        }
        
        if(!oppId.isEmpty()){
            System.enqueueJob(new OpportunityRevenueCalculateQueueable(oppId));
        }
    }
}