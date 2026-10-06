public class MapClass {
    public MapClass(){
        System.debug('Constructor called');
    }
    
    public static void show(){
        /*Map<Id,List<Contact>> maps = new Map<Id,List<Contact>>();
List<Contact> contacts= [SELECT Id,Name,Phone,Email FROM Contact where AccountID=''];


Map<Integer,String> student =new Map<Integer,String>();
student.put(101,'Uday');
student.put(102,'Nayan');
student.put(103,'Aryan');
student.put(104,'Ashok');
student.put(105,'Bhavya');
student.put(106,'Bhanu');

//System.debug(student);

for(integer k:student.keySet()){
System.debug('Roll number is: '+ k +'    Student Name is: '+ student.get(k));
}

System.debug(student.containsKey(108));*/
        
        /* List<Account> accountList=[Select Id from Account];

Map<Id,List<Contact>> mapss = new Map<Id,List<Contact>>();
for(Account acc : accountList){
List<Contact> contactts = [SELECT Id, Name, Phone, Email FROM Contact WHERE AccountId = :acc.Id LIMIT 100];
mapss.put(acc.Id, contactts);
}

for(Id id:mapss.keySet()){
System.debug('Id is: ' +id);
System.debug('Records with that id is: '+mapss.get(id));
}




Map<Id,List<Contact>> maps1 = new Map<Id,List<Contact>>();
for(Account account : [SELECT Id,(SELECT Id,Name,Phone,Email,BirthDate FROM Contacts)FROM Account]){
maps1.put(account.Id,account.contacts);
}



Map<Id,List<Contact>> contactsWithAccounts= new Map<Id,List<Contact>>();
List<Account> accountLists=[SELECT Id,Name,(SELECT Id,Salutation,FirstName,LastName,Email,Phone,BirthDate FROM Contacts)FROM Account WHERE Industry='Technology'];

for(Account acc: accountLists){
if(acc.Contacts !=null && !acc.Contacts.isEmpty()) {
if(acc.Contacts!=null && ! acc.Contacts.isEmpty() ){
contactsWithAccounts.put(acc.Id,acc.Contacts);
}
}   
}*/
        
        
        Map<Id,List<Contact>> accContactMap = new Map<Id,List<Contact>>();
        List<Account> accountListsNew=[SELECT Id,Name,(SELECT Id,Salutation,FirstName,LastName,Email,Phone,BirthDate FROM Contacts)FROM Account];
        
        for(Account acc:accountListsNew){
            accContactMap.put(acc.Id,acc.Contacts);
        }
        
        /*for(Id accId : accContactMap.keySet()){
List<Contact>getAllContactsOfThisAccount=accContactMap.get(accId);
System.debug('Account Name is: '+accId+' The total Contact for this account is:  '+accContactMap.get(accId).size());

if(getAllContactsOfThisAccount.size()>0){

for(Contact con : getAllContactsOfThisAccount){
System.debug('Contact Name is: '+ con.Salutation +' '+con.FirstName +' '+ con.LastName + '     Email is: '+ con.Email);
}  

}  
}*/
        
        for(Id accId : accContactMap.keySet()){
            System.debug('Account Name is: '+accId+' The total Cotact for this account is:  '+accContactMap.get(accId).size());
            
            if(accContactMap.get(accId).size()>0){
                for(Contact con: accContactMap.get(accId))
                    System.debug('Contact Name is: '+ con.Salutation +' '+con.FirstName +' '+ con.LastName + '     Email is: '+ con.Email);
            }
        }
        
        
        
        
        
        
        
        
        
        //List<Account> accounts=[SELECT]
        
        //List<Account> accounts=[SELECT Name,(SELECT COUNT(contact.phone) from contacts) FROM account GROUP BY accountName];
        
        
        //Map<String,Integer> accounts= new Map<String,Integer>();
        //List<Account>accountss=[SELECT Id,Name from Account];
        
        //for(String accountKey:accountss.Id){
        /*if(!accounts.containsKey(accountKey)){
        accounts.put(accountKey,1);
        }
        else{
        	
        }*/
        
        
        /*List<Contact> contactss=[SELECT Id,accountId from Contact where AccountId!=null];

        Map<Id,Integer> countMap= new Map<Id,Integer>();
        for (Contact con : contactss){
        Integer totalContacts=0;
        if(countMap.containsKey(con.AccountId)){
        totalContacts=countMap.get(con.accountId);
        }
        countMap.put(con.accountId,++totalContacts);
        }*/
        
        List<List <SObject>> searchList= [FIND 'iBirds' IN ALL FIELDS RETURNING Account(Name),Contact(Name,Email),Lead(Name,Email),Opportunity(Name)];
        List <Account> accList=(List<Account>)searchList[0];
        List <Contact> conList=(List<Contact>)searchList[1];
        List <Lead> leadList=(List<Lead>)searchList[2];
        List <Opportunity> oppList=(List<Opportunity>)searchList[3];
        
        System.debug('Accounts Found'+accList.size());
        System.debug('Contact Found'+conList.size());
        System.debug('Lead Found'+leadList.size());
        System.debug('Opportunities Found'+oppList.size());
        
        Map<Id,Account> accountMap=new Map<Id,Account>((List<Account>)searchList[0]);
        Map<Id,Contact> contactMap=new Map<Id,Contact>((List<Contact>)searchList[1]);
        Map<Id,Lead> leadMap=new Map<Id,Lead>((List<Lead>)searchList[2]);
        Map<Id,Opportunity> opportunityMap=new Map<Id,Opportunity>((List<Opportunity>)searchList[3]);
        
        System.debug('========= Accounts Records ========');
        if(accountMap.isEmpty()){
            System.debug('No accounts found');
        }
        else{
            Integer count =1;
            for(Account acc: accountMap.values()){
                System.debug(count +' ) Account Name: '+acc.Name+ ' | Account Id: '+ acc.Id);
                count++;
            }
        }
        
        System.debug('========= Contacts Records ========');
        if(contactMap.isEmpty()){
            System.debug('No contacts found');
        }
        else{
            Integer count =1;
            for(Contact con: contactMap.values()){
                System.debug(count +' ) Contact Name: '+con.Name + ' | Contact Email: '+ con.Email + ' | Contact Id: '+ con.Id);
                count++;
            }
        }
        
        System.debug('========= Leads Records ========');
        if(leadMap.isEmpty()){
            System.debug('No leads found');
        }
        else{
            Integer count =1;
            for(Lead lead: leadMap.values()){
                System.debug(count +' ) Lead Name: '+lead.Name+ ' | Lead Email: '+ lead.Email +' | Lead Id: '+ lead.Id);
                count++;
            }
        }
        
        System.debug('========= Opportunities Records ========');
        if(opportunityMap.isEmpty()){
            System.debug('No opportunities found');
        }
        else{
            Integer count =1;
            for(Opportunity opp: opportunityMap.values()){
                System.debug(count +' ) Opportunity Name: '+opp.Name + ' | Opportunity Id: '+ opp.Id);
                count++;
            }
        }
        
        
        
    }        
}