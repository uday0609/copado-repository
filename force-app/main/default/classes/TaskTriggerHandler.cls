public class TaskTriggerHandler {
    // Created by Uday on 11 Mar 2026 for shifting the task due date to the next working day if it is sat or sun
    public static void changeDueDate(List<Task> taskList, Map<Id,Task> oldMap){
        if(taskList != null){
            for(Task task : taskList){
                Task oldTask = (oldMap != null) ? oldMap.get(task.Id) : null;
                
                if(task.ActivityDate != null || (oldTask != null && oldTask.ActivityDate != task.ActivityDate )){
                    DateTime dt = DateTime.newInstance(task.ActivityDate.year(), task.ActivityDate.month(), task.ActivityDate.day());
                    String dayOfWeek = dt.format('EEEE');
                    
                    if(dayOfWeek == 'Saturday'){
                        task.ActivityDate = task.ActivityDate.addDays(2);
                    }
                    else if(dayOfWeek == 'Sunday'){
                        task.ActivityDate = task.ActivityDate.addDays(1);
                    }
                } 
            }  
        }
    }
}