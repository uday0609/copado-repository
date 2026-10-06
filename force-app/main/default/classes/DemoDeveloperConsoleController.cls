public class DemoDeveloperConsoleController {
    public demoDeveloperConsoleController(){
        System.debug('Constructor called');
    }
    
    public static void show(){
        integer i=0;
        ID id =null;
        String name ='I birds services';
        double price =56.88;
        boolean answer=false;
        System.debug('Show Method called');
    }
    
    
    public void getContact(){
        /*List<Contact>contact =[SELECT ID,FirstName,LastName,Email,Phone FROM Contact];
        
         List<Contact> contactes = new List<Contact>();
         contactes = [SELECT ID,FirstName,LastName,Email,Phone FROM Contact];
        
        
        List <String> city = new List<String>();
        List <String> cities= new List<String>{'Ajmer','Jaipur','Udaupur','Jodhpur'};
                
        System.debug(cities);
        System.debug('City at 0'+cities.get(0));
        System.debug('City at 0'+cities.get(1));
        System.debug('City at 0'+cities.get(2));
        
        
        
        for(Contact con :contact){
            System.debug(con.firstName);
            System.debug(con.lastName);
            System.debug(con.email);
            System.debug(con.phone);
        }
        
        contact =[SELECT ID,FirstName,LastName,Email,Phone FROM Contact where email = 'tttt@gmail.com'];
		        
        
        System.debug(contact);
        System.debug(contact.size());*/
        
       /*Contact contact =[SELECT ID,FirstName,LastName,Email,Phone FROM Contact WHERE email='tttE@gmail.com'];
        system.debug(contact); --->error*/
        
        
        List<Contact>contact =[SELECT ID,FirstName,LastName,Email,Phone FROM Contact];
        system.debug(contact);
    }
  
}