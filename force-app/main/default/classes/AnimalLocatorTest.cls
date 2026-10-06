@isTest
public class AnimalLocatorTest{

    @isTest
    public static void testGetAnimalNameByIdCopy() {

        Test.setMock(HttpCalloutMock.class, new AnimalLocatorMock());
        Test.startTest();
        String result = AnimalLocator.getAnimalNameByIdCopy(1);
        Test.stopTest();
        System.assertEquals('Mock Animal', result);
    }
}