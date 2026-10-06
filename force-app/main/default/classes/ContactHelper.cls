public class ContactHelper {
    //Created by Uday on 2 Mar 2026 for contact phone validation check
    public static void validatePhone(List<Contact> conList){
        for(Contact con : conList){
            if(con.Phone == null){
                con.addError('Phone is required');
            }
        }
    }
    
    //Created by Uday on 6 Mar 2026 for contact unique validation check
    public static void uniqueEmail(List<Contact>conList){
        Set<String> emailSet = new Set<String>();
        for(Contact con : conList){
            if(con.Email != null){
                emailSet.add(con.Email);
            }
        }
        Set<String> getDatabaseContactEmail = new Set<String>();
        for(Contact con : [SELECT Email FROM Contact WHERE Email IN : emailSet ]){
            getDatabaseContactEmail.add(con.Email);
        }        
        Set<String>processedEmail = new Set<String>();
        for(Contact con : conList){
            if(getDatabaseContactEmail.contains(con.Email) || processedEmail.contains(con.Email)){
                con.addError('Email Already Excists');
            }
            if(con.Email == null){
                con.addError('Email is required');
            }
        }
    }
    
    // Created by Uday on 4 Mar 2026 for updating total salary of account when the new contact is created, updated or deleted
    public static void updateTotalSalaryOnNewContact(List<Contact> conList,Map<Id,Contact> oldMap){
        Set<Id> accId= new Set<Id>();
        for(Contact con : conList){
            if(con.AccountId != null){
                accId.add(con.AccountId);
            }
            if(oldMap != null && oldMap.get(con.Id).AccountId !=null && oldMap.get(con.Id).AccountId != con.AccountId){
                accId.add(oldMap.get(con.Id).AccountId);
            }
        }
        
        if(!accId.isEmpty()){
            Map<Id,Decimal> accMap = new Map<Id,Decimal>();
            for(AggregateResult ar: [SELECT AccountId, SUM (Salary__c) Total_Salary FROM Contact WHERE AccountId IN : accId GROUP BY AccountId ] ){
                accMap.put((Id)ar.get('AccountId'),(Decimal)ar.get('Total_Salary'));
            }
            
            List<Account> accountUpdate = new List<Account>();
            for(Id id : accId){
                accountUpdate.add(new Account(Id = id, Total_Salary__c = accMap.get(id) ?? 0 ));
            }
            if(!accountUpdate.isEmpty()){
                update accountUpdate;
            }
        }
    }
    
    //Extra questions
    //Created by Uday on 05 Mar 2026 for updating the field of family count of account and family member of related contacts through the number of contacts as soon as new contact is inserted, updated and deleted
    public static void updateAccountContactFields(List<Contact>conList,Map<Id,Contact>oldMap){
        Set<Id> accSet = new Set<Id>();
        for(Contact con : conList){
            if(Trigger.isUpdate && con.AccountId == oldMap.get(con.Id).AccountId) continue;
            if(con.AccountId != null){
                accSet.add(con.AccountId);
            }
            if(oldMap != null && oldMap.get(con.Id).AccountId != null && oldMap.get(con.Id).AccountId != con.AccountId){
                accSet.add(oldMap.get(con.Id).AccountId);
            }
        }
        if(accSet.isEmpty()) return;
        Map<Id,Integer> accMap = new Map<Id,Integer>();
        for(AggregateResult ar: [SELECT AccountId, COUNT(Id) Total_Contacts FROM Contact WHERE AccountId IN : accSet GROUP BY AccountId]){
            accMap.put((Id)ar.get('AccountId'),(Integer)ar.get('Total_Contacts'));
        }
        
        List<Account> acc = new List<Account>();
        for(Id id : accSet){
            acc.add(new Account(Id = id, Family_Count__c = accMap.get(id) ?? 0));
        }
        System.debug('List '+acc);
        if(!acc.isEmpty()){
            update acc;
        }
        
        List<Contact> newConList = [SELECT AccountId,Id,Family_Member__c FROM Contact WHERE AccountId IN : accMap.keySet()];
        for(Contact con : newConList){
            con.Family_Member__c = accMap.get(con.AccountId);
        }
        update newConList;
    }  
    
    // Created by Uday on 11 Mar 2026 for updating account score 1 and 2 when the new contact is inserted, updated, deleted and undeleted
    public static void updateAccountScore(List<Contact> conList, Map<Id,Contact> oldMap){
        Set<Id> accSet = new Set<Id>();
        for(Contact con: conList){
            if(con.AccountId != null && (con.Score1__c != null ||  con.Score2__c != null)){
                accSet.add(con.AccountId);
            }
            if(oldMap != null && oldMap.get(con.Id).AccountId != null && oldMap.get(con.Id).AccountId != con.AccountId){
                accSet.add(oldMap.get(con.Id).AccountId);
            }
        }
        Map<Id,Account> accountMap = new Map<Id,Account>();
        for(AggregateResult ar :  [SELECT AccountId,SUM(Score1__c) score1 ,SUM(Score2__c) score2 FROM Contact WHERE AccountId IN: accSet GROUP BY AccountId]){
            accountMap.put((Id)ar.get('AccountId'),new Account(Id = (Id)ar.get('AccountId'),Account_Score1__c = (Decimal)ar.get('score1'),Account_Score2__c = (Decimal)ar.get('score2')));
        }
        List<Account> accList = new List<Account>();
        for(Id id : accSet){
            accList.add(new Account(Id = id,Account_Score1__c = (Decimal)accountMap.get(id).Account_Score1__c ?? 0, Account_Score2__c = (Decimal)accountMap.get(id).Account_Score2__c ?? 0));        }
        update accList;
    }
    
    // Created by Uday on 30 Mar 2026 for tracking the email change and storing it in the previous email field 
    public static void trackEmailChange(List<Contact> conList, Map<Id,Contact> oldMap){
        for(Contact con : conList){
            if(con.Email != oldMap.get(con.Id).Email){
                if(oldMap.get(con.Id).Email != null){
                    con.Previous_Email__c = oldMap.get(con.Id).Email;
                }
            }
        }
    }
    
    public static void insertContactLog(List<Contact> conList,Map<Id,Contact> oldMap){
        if(!conList.isEmpty()){
            List<Contact> conRecord = new List<Contact>(); 
            Map<Id,Contact> oldDataChanged = new Map<Id,Contact>();
            for(Contact con : conList){
                if(oldMap != null && con.Email != null && con.Phone != null && oldMap.get(con.Id).Phone != null && oldMap.get(con.Id).Email != null && (oldMap.get(con.Id).Phone != con.Phone || oldMap.get(con.Id).Email != con.Email)){
                    conRecord.add(con);
                    oldDataChanged.put(con.Id, oldMap.get(con.Id));
                }
            }
            if(!conRecord.isEmpty()){
                ContactFutureClass.insertRecordInContact(JSON.Serialize(conRecord),JSON.Serialize(oldDataChanged));
            } 
        }
    }
}