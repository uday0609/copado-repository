public class ContactFutureClass {
    @future
    public static void insertRecordInContact(String updatedData,String oldChangedData){
        Map<Id, Contact> oldRecord = (Map<Id, Contact>)JSON.deserialize(oldChangedData,Map<Id, Contact>.class);
        List<Contact> conList = (List<Contact>)JSON.deserialize(updatedData,List<Contact>.class);
        
        List<Contact_Update_Log__c> conLogList = new List<Contact_Update_Log__c>();
        for(Contact con : conList){
            if(con.Email != oldRecord.get(con.Id).Email && con.Phone != oldRecord.get(con.Id).Phone){
                conLogList.add(new Contact_Update_Log__c(Contact__c = con.Id, Old_Email__c = oldRecord.get(con.Id).Email, New_Email__c = con.Email, Old_Phone__c = oldRecord.get(con.Id).Phone, New_Phone__c = con.Phone));
            }
            
            else if(con.Email != oldRecord.get(con.Id).Email){
                conLogList.add(new Contact_Update_Log__c(Contact__c = con.Id, Old_Email__c = oldRecord.get(con.Id).Email, New_Email__c = con.Email));
            }
            
            else if(con.Phone != oldRecord.get(con.Id).Phone){
                conLogList.add(new Contact_Update_Log__c(Contact__c = con.Id, Old_Phone__c = oldRecord.get(con.Id).Phone, New_Phone__c = con.Phone));
            }
            
        }
        if(!conLogList.isEmpty()){
        	insert conLogList;   
        }
    }
}