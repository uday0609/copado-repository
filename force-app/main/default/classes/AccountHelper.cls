public class AccountHelper {
    
    public Static Boolean isFirstUpdate = false;
    
    // Created by Uday on 02 Mar 2026 for setting account description when the account is created
    public static void setDescription(List<Account> accList){
        for(Account acc : accList){
            if(acc.Description != null){
                acc.addError('Description is read only');
            }
            else{
                acc.Description = 'Account created on ' + System.today() ;
            }   
        }
    }
    
    // Created by Uday on 02 Mar 2026 for creating contact when the account is created
    public static void createContact(List<Account> accList){
        List<Contact> contactToBeInserted = new List<Contact>(); 
        for(Account acc : accList){
            Contact con = new Contact();
            con.AccountId = acc.Id;
            con.FirstName = 'Test';
            con.LastName = acc.Name;
            con.Email = 'contact@ibirdsservices.com';
            con.Phone='1234567890'; 
            contactToBeInserted.add(con);     
        }
        
        if(contactToBeInserted.size()>0){
            insert contactToBeInserted;
        } 
    }
    
    // Created by Uday on 02 Mar 2026 for updating the description field of the account whenver the account is updated
    public static void UpdateDescription(List<Account> accList){
        if(isFirstUpdate == false){
            isFirstUpdate = true;
            for(Account acc : accList){
                Account accNew = new Account(Id = acc.Id);
                accNew.Description = 'Account info is changed on ' + acc.LastModifiedDate ;
                update accNew;
            }
        }
    }
    
    // Created by Uday on 02 Mar 2026 for updating the Change_Industry field when the account type is updated
    public static void trackIndustryChange(List<Account> newList, Map<Id, Account> oldMap){
        for(Account acc : newList){
            if(acc.Industry != oldMap.get(acc.Id).Industry){
                acc.Change_Industry__c = 'Old Industry: ' + (oldMap.get(acc.Id).Industry == null ? 'Blank' : oldMap.get(acc.Id).Industry) + ' | New Industry: ' + (acc.Industry == null ? 'Blank' : acc.Industry) + ' | Changed On: ' + System.now();                    
            }    
        }     
    }
    
    // Created by Uday on 02 Mar 2026 for updating the Contact_Industry field when the account industry is updated
    public static void changeContactIndustry(List<Account> accList, Map<Id,Account> oldMap ){
        for(Account acc : accList){
            List<Contact> relatedContact = [SELECT Contact_Industry__c FROM Contact WHERE AccountId = : acc.Id];
            if(acc.Industry != oldMap.get(acc.Id).Industry){
                for(Contact con : relatedContact){
                    con.Contact_Industry__c = acc.Industry;
                    update con;
                }
            }
        }
    }
    
    // Created by Uday on 4 Mar 2026 for updating opportunity stage type field accordingly as per the change in account type field
    public static void changeOpportunityStageType(List<Account> accList) {
        Map<Id, String> accIdToTypeMap = new Map<Id, String>();
        for (Account acc : accList) {
            String stageValue;
            if (acc.Account_Type__c == null) stageValue = '0';
            else if (acc.Account_Type__c == 'Reseller') stageValue = '10';
            else if (acc.Account_Type__c == 'Buyer') stageValue = '25';
            else if (acc.Account_Type__c == 'Current Customer') stageValue = '100';
            accIdToTypeMap.put(acc.Id, stageValue);
        }
        List<Opportunity> oppsToUpdate = [SELECT Id, AccountId, Stage_Type__c FROM Opportunity WHERE AccountId IN :accIdToTypeMap.keySet()];
        for (Opportunity opp : oppsToUpdate) {
            opp.Stage_Type__c = accIdToTypeMap.get(opp.AccountId);
        }
        if (!oppsToUpdate.isEmpty()) {
            update oppsToUpdate;
        }
    }
    
    // Extra questions for practice on trigger
    // Created by Uday on 7 Mar 2026 for updating child contacts description as soon the account type changes
    public static void updateContactDescription(List<Account> accList,Map<Id,Account> oldMap){
        Map<Id,Account> accMap = new Map<Id,Account>();
        for(Account acc : accList){
            if(acc.Type != oldMap.get(acc.Id).Type){
                accMap.put(acc.Id,acc);
            }
        }
        
        List<Contact> conListUpdate = new List<Contact>();
        for(Contact con : [SELECT AccountId,Id,Description FROM Contact WHERE AccountId IN : accMap.keySet() ]){
            con.Description = 'Account Type is : ' + accMap.get(con.AccountId).Type;
            conListUpdate.add(con);
        }        
        update conListUpdate;
    }
    
    // Created by Uday on 13 Mar 2026 for preventing the deletion of account when the account has any open opportunities
    public static void preventAccountDeletion(List<Account> accList){
        Set<Id> accId = new Set<Id>();
        for(Account acc: accList){
            accId.add(acc.Id);  
        }
        Set<Id> relatedAccountId = new Set<Id>();
        for(Opportunity opp: [SELECT AccountId, StageName FROM Opportunity WHERE AccountId IN : accId AND StageName != 'Closed Won' AND StageName !='Closed Lost']){
            relatedAccountId.add(opp.AccountId);   
        }
        for(Account acc : accList){
            if(relatedAccountId.contains(acc.Id)){
                acc.addError('Account cannot be deleted with the open opportunity');
            }
        }
    } 
    
    // Created by Uday on 18 Mar 2026 for adding account team member in the child when the owner of the parent account is updated or the parent account is changed
    public static void addAccountTeamMembers(List<Account> accList,Map<Id,Account> oldMap){
        if(!accList.isEmpty()){
            if(Trigger.isBefore){
                for(Account acc : accList){                    
                    if(acc.VPA__c == TRUE && acc.ParentId != null)	
                        acc.ParentId.addError('If VPA is checked then parent id should be left blank');
                    else if(acc.VPA__c == FALSE && acc.ParentId == null)	
                        acc.ParentId.addError('If VPA is not checked then parent account must be filled');
                }
            }
            else if(Trigger.isAfter){
                Set<Id> accParentIdSet = new Set<Id>();
                for(Account acc : accList){
                    if(acc.ParentId != null || (oldMap != null && acc.ParentId != oldMap.get(acc.Id).ParentId)) 
                        accParentIdSet.add(acc.ParentId);
                    
                    if(acc.VPA__c == TRUE && acc.ParentId == null && oldMap!= null && acc.OwnerId != oldMap.get(acc.Id).OwnerId) 
                        accParentIdSet.add(acc.Id);
                }
            
                Map<Id,Account> parentAccount = new Map<Id,Account>([SELECT Id,Name,OwnerId FROM Account WHERE Id IN: accParentIdSet ]);
                List<AccountTeamMember> accountMemberInsert = new List<AccountTeamMember>();
                
                if(Trigger.isInsert){
                    for(Account acc : accList){
                        if(acc.ParentId != null && acc.VPA__c == FALSE && parentAccount.containsKey(acc.ParentId))	
                            accountMemberInsert.add(new AccountTeamMember(AccountId = acc.Id, UserId = parentAccount.get(acc.ParentId).OwnerId, TeamMemberRole = 'Account Manager'));
                    }
                    
                    if(!accountMemberInsert.isEmpty())	insert accountMemberInsert;   
                }
                
                else if(Trigger.isUpdate){
                    List<Account> childRecord = [SELECT Id,ParentId FROM Account WHERE ParentId IN: accParentIdSet];
                    Set<Id> childRecordId = new Set<Id>();
                    for(Account acc : childRecord)
                        childRecordId.add(acc.Id);
                    
                    if(!childRecordId.isEmpty())
                        delete [SELECT Id,AccountId FROM AccountTeamMember WHERE AccountId IN: childRecordId];
                    
                    for(Account acc : childRecord){
                        if(parentAccount.containsKey(acc.ParentId))
                            accountMemberInsert.add(new AccountTeamMember(AccountId = acc.Id, UserId = parentAccount.get(acc.ParentId).OwnerId, TeamMemberRole = 'Account Manager'));
                    }
                    
                    if(!accountMemberInsert.isEmpty()) insert accountMemberInsert;
                }
            } 
        }	
    }
}