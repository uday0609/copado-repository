public class AccountMonthlyScheduler implements Schedulable{
    
    public void execute(SchedulableContext sc){
        Database.executeBatch(new AccountMonthlyBatch(),100);
    }
}