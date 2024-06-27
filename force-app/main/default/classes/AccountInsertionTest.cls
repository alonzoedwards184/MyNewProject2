@isTest
public class AccountInsertionTest {

    @isTest
    static void testCreateNewAccount_Success() {
        // Test case for successful account creation
        Test.startTest();
        AccountInsertion.createNewAccount('Test Account', '123-456-7890', 'http://www.example.com');
        Test.stopTest();

        // Verify the account was created
        Account insertedAccount = [SELECT Id, Name, Phone, Website FROM Account WHERE Name = 'Test Account' LIMIT 1];
        System.assertEquals('Test Account', insertedAccount.Name);
        System.assertEquals('123-456-7890', insertedAccount.Phone);
        System.assertEquals('http://www.example.com', insertedAccount.Website);
    }

    @isTest
    static void testCreateNewAccount_ErrorHandling() {
        // Test case for error handling during account creation
        Test.startTest();
        // Inserting an account with a duplicate name to force an exception
        try {
            AccountInsertion.createNewAccount('Test Account', '123-456-7890', 'http://www.example.com');
            AccountInsertion.createNewAccount('Test Account', '111-222-3333', 'http://www.example.org'); // This should throw an exception
        } catch (Exception e) {
            String expectedErrorMessage = 'FIELD_CUSTOM_VALIDATION_EXCEPTION, Account with this name already exists: []';
            System.assertEquals(expectedErrorMessage, e.getMessage());
        }
        Test.stopTest();
    }
}
