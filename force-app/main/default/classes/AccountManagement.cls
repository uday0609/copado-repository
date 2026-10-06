@RestResource(urlMapping = '/accountmanagement/')
global class AccountManagement {
    /*@httpGet 
    global static List<Account> getTopAccount(){
        Map<String,String> paramsMap = RestContext.request.params;
        String accIndustry = paramsMap.get('Industry');
        List<Account> accList = [SELECT Id,Industry,Rating,annualRevenue FROM Account WHERE annualRevenue != null AND Industry =: accIndustry order by annualRevenue desc limit 10 ];
        return accList;
    }*/
    
    /*@httpGet 
    global static AccountWrappers getTopAccount(){
        Set<Id> accId = new Set<Id>();
        Map<String,String> paramsMap = RestContext.request.params;
        String accIndustry = paramsMap.get('Industry');
        List<Account> accList = [SELECT Id,Industry,Rating,annualRevenue FROM Account WHERE annualRevenue != null AND Industry =: accIndustry order by annualRevenue desc limit 10 ];
        for(Account acc : accList){
            accId.add(acc.Id);            
        }
        List<Contact> conList = [SELECT Id,firstName,lastName,Email FROM Contact WHERE accountId IN : accId];
        List<Case> caseList = [SELECT Id,Priority,Subject FROM Case WHERE accountId IN: accId];
        
        AccountWrappers accWrapper = new AccountWrappers();
        accWrapper.accList = accList;
        accWrapper.conList = conList;
        accWrapper.caseList = caseList;
        
        return accWrapper;
    }*/
    
    @httpGet 
    global static AccountWrappers getTopAccount(){
        Map<String,String> paramsMap = RestContext.request.params;
        String accId = paramsMap.get('Id');
        List<Account> accList = [SELECT Id,Name,Rating,AnnualRevenue FROM Account WHERE Id =: accId];
        List<Contact> conList = [SELECT Id,firstName,lastName,Email FROM Contact WHERE accountId =: accId];
        List<Case> caseList = [SELECT Id,Priority,Subject FROM Case WHERE accountId =: accId];
        List<Opportunity> oppList = [SELECT Id,Name,Amount,StageName FROM Opportunity WHERE accountId =: accId];
        
        AccountWrappers accWrapper = new AccountWrappers();
        accWrapper.accList = accList;
        accWrapper.conList = conList;
        accWrapper.caseList = caseList;
        accWrapper.oppList = oppList;
        
        return accWrapper;
    }
    
    /*@httpPost
    global static String createAccount(String accName,String accRating,String accIndustry){
        Account acc = new Account();
        acc.Name =  accName;
        acc.Rating = accRating;
        acc.Industry = accIndustry;
        
        try{
            insert acc;
            return 'Account Created Successfully';
        }
        catch(Exception e){
            return e.getMessage();
        }
    }*/
    
    @HttpPost
    global static String createAccountAndContact(){ 
        try{
            AccountList accountData = (AccountList) JSON.deserialize(RestContext.request.requestBody.toString(),AccountList.class);
            List<Account> accToInsert = new List<Account>();
            for(AccountWrapper aw : accountData.data){
                accToInsert.add(aw.acc);
            }
            Database.insert(accToInsert,false);
            System.debug('Account inserted successfully');
            List<Contact> conToInsert = new List<Contact>();
            for(Integer i=0; i<accountData.data.size(); i++){
                Account insertedAccount = accToInsert[i];
                System.debug('Inserted Account ' + insertedAccount);
                List<Contact> relatedContact = accountData.data[i].conList;
                if(!relatedContact.isEmpty()){
                    for(Contact con : relatedContact){
                        con.AccountId = insertedAccount.Id;
                        conToInsert.add(con);
                    }
                }
            }
            Database.insert(conToInsert,false);
            return 'Success';
        }
        catch(Exception e){
            System.debug('error' +  e.getMessage());
            return 'Error: ' + e.getMessage();
        }
    }
    
    /*@HttpDelete
    global static String deleteAccount(){
        Map<String,String> paramsMap = RestContext.request.params;
        String accountId = paramsMap.get('Id');
        List<Account> accList = [SELECT Id FROM Account WHERE Id =: accountId];
        if(!accList.isEmpty()){
            try{
                delete accList;
                return 'Account Deletion Successfully';
            }
            catch(Exception e){
                return e.getMessage();
            }
        }
        else{
            return 'Record not found';
        }
    }*/
    
    @HttpDelete
    global static AccountWrappers DeleteAccountAndRelatedRecords(){
        Set<Id> accId = new Set<Id>();
        Map<String,String> paramsMap = RestContext.request.params;
        List<Account> accList = [SELECT Id FROM Account WHERE Id =: paramsMap.get('Id')];
        List<Contact> conList = [SELECT Id FROM Contact WHERE accountId =: paramsMap.get('Id')];
        List<Case> caseList = [SELECT Id FROM Case WHERE accountId =: paramsMap.get('Id')];
        List<Opportunity> oppList = [SELECT Id FROM Opportunity WHERE accountId =: paramsMap.get('Id')];
        
        AccountWrappers accWrapper = new AccountWrappers();
        accWrapper.accList = accList;
        accWrapper.conList = conList;
        accWrapper.caseList = caseList;
        accWrapper.oppList  = oppList;
        
        delete accWrapper.caseList;
        delete accWrapper.conList;
        delete accWrapper.oppList;
        delete accWrapper.accList;
        
        return accWrapper;
    }
    
    global class AccountWrappers{
        global List<Account> accList;
        global List<Contact> conList;
        global List<Case> caseList;
        global List<Opportunity> oppList;
    }
    
    global class AccountList {
        global List<AccountWrapper> data {get; set;}
    }
    
    global class AccountWrapper {
        global Account acc {get; set;}
        global List<Contact> conList {get; set;}
    }
}