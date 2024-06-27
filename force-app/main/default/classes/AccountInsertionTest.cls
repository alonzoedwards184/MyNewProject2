@isTest
public class AccountInsertionTest {
    @isTest
    static void testCreateNewAccount_Success() {
        // Test case for successful account creation
        Test.startTest();
        AccountInsertion.createNewAccount('Test Account', '123-456-7890', 'http://www.example.com', 'Customer');
        Test.stopTest();

        // Verify the account was created
        Account insertedAccount = [SELECT Id, Name, Phone, Website, Type FROM Account WHERE Name = 'Test Account' LIMIT 1];
        System.assertEquals('Test Account', insertedAccount.Name);
        System.assertEquals('123-456-7890', insertedAccount.Phone);
        System.assertEquals('http://www.example.com', insertedAccount.Website);
        System.assertEquals('Customer', insertedAccount.Type);
    }
}
