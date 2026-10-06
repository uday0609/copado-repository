public class CustomNotificationApexClass {
    
    public static void notifyUsers(Set<String> recipientId, String targetId){
        List<CustomNotificationType> notificationType = [SELECT Id,DeveloperName FROM CustomNotificationType WHERE DeveloperName = 'New_Custom_Notification' WITH USER_MODE LIMIT 1];
        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        notification.setTitle('Apex Custom Notification');
        notification.setBody('Custom Notification Body');
        if(!notificationType.isEmpty()){
            for(CustomNotificationType ntype : notificationType){
                notification.setNotificationTypeId(nType.id);   
            }
        }
        notification.setTargetId(targetId);
        
        try{
            notification.send(recipientId);
        }
        catch(Exception e){
            System.debug('Error while sending notification   ' + e.getMessage());
        }
    }
}