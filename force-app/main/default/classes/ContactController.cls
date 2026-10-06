public class ContactController {
    
    public List<ContactWrapper> contacts { get; set; }
    public Integer pageNumber { get; set; }
    public Integer pageSize { get; set; }
    public Integer totalRecords { get; set; }
    public Boolean hasNext { get; set; }
    public Boolean hasPrevious { get; set; }
    public String selectedFilter { get; set; }
    public Integer currentIndex {get; set;}
    
    
    public ContactController() {
        pageNumber = 1;
        pageSize = 20;
        selectedFilter = 'All';
        loadContacts();
    }
    
    public List<SelectOption> getFilterOptions() {
        return new List<SelectOption>{
            new SelectOption('All','All'),
                new SelectOption('BulkMessageContacts','Bulk SMS Contacts'),
                new SelectOption('NewLastWeek','New Last Week'),
                new SelectOption('BirthdaysThisMonth','Birthdays This Month'),
                new SelectOption('RecentlyViewedContacts','Recently Viewed Contacts'),
                new SelectOption('MyContacts','My Contacts'),
                new SelectOption('Staff_View','Staff View'),
                new SelectOption('This_Week','This Week'),
                new SelectOption('Student_View','Student View')
                
                };
                    }
    
    public void loadContacts() {
        //Integer offsetValue = (pageNumber - 1) * pageSize;
        String baseQuery = 'FROM Contact';
        
        System.debug(selectedFilter);
        
        if(selectedFilter != 'All'){
            if(selectedFilter == 'BulkMessageContacts'){
                baseQuery += '';
            }
            else if(selectedFilter == 'NewLastWeek'){
                baseQuery += ' WHERE CreatedDate = LAST_WEEK ';
            }
            else if(selectedFilter == 'BirthdaysThisMonth'){
                baseQuery += ' WHERE Birthdate = THIS_MONTH  ';
            }
            else if(selectedFilter == 'RecentlyViewedContacts'){
                baseQuery += ' WHERE LastViewedDate = LAST_MONTH  ';
            }
            else if(selectedFilter == 'MyContacts'){
                baseQuery += ' WHERE CreatedBy = UserInfo.getUserId()';
            }
            else if(selectedFilter == 'Staff_View'){
                baseQuery += ' WHERE RecordType.DeveloperName = \'Staff\'';
            }
            else if(selectedFilter == 'This_Week'){
                baseQuery += ' WHERE CreatedDate = THIS_WEEK ';
            }
            else if(selectedFilter == 'Student_View'){
                baseQuery += ' WHERE RecordType.DeveloperName = \'Student\'';
            }
            
        }
        System.debug('baseQuery '+baseQuery);
        totalRecords = Database.countQuery('SELECT COUNT() ' + baseQuery);
        String finalQuery ='SELECT Id, Name, Email, Phone, Gender__c, RecordType.DeveloperName ' +baseQuery +' ORDER BY CreatedDate ASC LIMIT :pageSize';
        List<Contact> contactList = Database.query(finalQuery);
        contacts = new List<ContactWrapper>();
        
        for(Contact c : contactList){
            contacts.add(new ContactWrapper(c));
        }
        
        hasPrevious = pageNumber > 1;
        hasNext = (pageNumber * pageSize) < totalRecords;
    }
    
    public void next() {
        pageNumber++;
        loadContacts();
    }
    
    public void previous() {
        pageNumber--;
        loadContacts();
    }
    
    public void applyFilter() {
        pageNumber = 1;
        loadContacts();
    }
    
    public PageReference deleteSelected() {
        List<Contact> toDelete = new List<Contact>();
        
        for(ContactWrapper cw : contacts){
            if(cw.isSelected){
                toDelete.add(cw.con);
            }
        }
        
        if(toDelete.isEmpty()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Select at least one record for delete .'));
            return null;
        }
        
        delete toDelete;
        
        loadContacts();
        return null;
    }
    
    public class ContactWrapper {
        public Contact con { get; set; }
        public Boolean isSelected { get; set; }
        
        public ContactWrapper(Contact c){
            con = c;
            isSelected = false; 
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(){
        return [SELECT FirstName, LastName, Email FROM Contact];
    }
}

// public with sharing class ContactController {
    // @AuraEnabled(cacheable=true)
    // public static List<Contact> getContacts(){
    //     return [SELECT FirstName, LastName, Email FROM Contact];
    // }
// }

// public with sharing class ContactController {
//     @AuraEnabled(cacheable=true)
//     public static List<Contact> getContacts(){
//         throw new AuraHandledException('Unable to retrieve contacts.');
//     }
// }