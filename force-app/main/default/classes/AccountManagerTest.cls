@isTest
private class AccountManagerTest {

    @isTest
    static void testGetAccount() {

        Account acc = new Account(
            Name = 'Test Account'
        );

        insert acc;

        Contact con1 = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            AccountId = acc.Id
        );

        insert con1;

        RestRequest req = new RestRequest();

        req.requestURI =
            '/services/apexrest/Accounts/' +
            acc.Id +
            '/contacts';

        req.httpMethod = 'GET';

        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();

        Account result =
            AccountManager.getAccount();

        Test.stopTest();

        System.assertEquals(acc.Id, result.Id);
        System.assertEquals('Test Account', result.Name);
        System.assertEquals(1, result.Contacts.size());
    }
}