@isTest
public class TestRestrictContactByName {
	@isTest
    static void checkContactResult(){
        Contact con = new Contact(LastName = 'INVALIDNAME');
      	Test.startTest();
        insert con;
        Test.stopTest();
    }
    
    @isTest
    static void checkContactResults(){
        Contact con = new Contact(LastName = 'Punjani');
      	Test.startTest();
        insert con;
        Test.stopTest();
    }
}