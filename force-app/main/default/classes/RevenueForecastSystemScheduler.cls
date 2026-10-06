public class RevenueForecastSystemScheduler implements Schedulable{
    public void execute(SchedulableContext sc){
        try{
            Integer existingJobs = [SELECT count() FROM AsyncApexJob WHERE JobType = 'BatchApex' AND ApexClass.Name = 'RevenueForecastSystemBatch' AND Status = 'Completed' AND CompletedDate = TODAY];
            if(existingJobs == 0){
                Database.executeBatch(new RevenueForecastSystemBatch(),200);
            }   
        }
        catch(Exception e){
            System.debug('Error '+ e.getMessage());
        }
    }
}