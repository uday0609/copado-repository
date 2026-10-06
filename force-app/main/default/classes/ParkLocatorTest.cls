@isTest
private class ParkLocatorTest {

    @isTest
    static void testCountryMethod() {

        Test.setMock(
            WebServiceMock.class,
            new ParkServiceMock()
        );

        Test.startTest();

        List<String> parks =
            ParkLocator.country('United States');

        Test.stopTest();

        System.assertEquals(2, parks.size());
    }
}