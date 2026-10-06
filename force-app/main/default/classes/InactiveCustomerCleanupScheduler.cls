public class InactiveCustomerCleanupScheduler implements Schedulable{
    
    public void execute(SchedulableContext sc){
        List<Batch_Summary__c> batchJob = [SELECT Job_Name__c, Status__c, Batch_Run_Date__c FROM Batch_Summary__c WHERE Job_Name__c = 'Inactive Customer Clean Up Batch' AND Batch_Run_Date__c =: System.Today()];
        if(batchJob.isEmpty()){
            Batch_Summary__c batchData = new Batch_Summary__c(Job_Name__c = 'Inactive Customer Clean Up Batch',Batch_Run_Date__c = System.today(),Status__c = 'Started');
            insert batchData;
            Database.executeBatch(new InactiveCustomerCleanupBatch(batchData.Id), 200);
        }
    }
}