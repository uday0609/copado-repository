global class LeadCleanUpScheduler implements Schedulable{
    
    global void execute(SchedulableContext sc){
    	Database.executeBatch(new LeadCleanUpBatch(),200);
    }
}