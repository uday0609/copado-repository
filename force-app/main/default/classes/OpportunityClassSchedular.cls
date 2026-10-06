global class OpportunityClassSchedular implements Schedulable {
    
    global void execute(SchedulableContext sc){
        Database.executeBatch(new OpportunityClassBatch(),200);
    }
}