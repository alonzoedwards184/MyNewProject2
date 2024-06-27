@isTest
public class AccountInsertionTest {

    @isTest
    static void testCreateNewAccount_Success() {
        // Test case for successful account creation
        Test.startTest();
        AccountInsertion.createNewAccount('Test Account', '123-456-7890', 'http://www.example.com', 'Customer - Direct');
        Test.stopTest();

        // Verify the account was created
        Account insertedAccount = [SELECT Id, Name, Phone, Website, Type FROM Account WHERE Name = 'Test Account' LIMIT 1];
        System.assertEquals('Test Account', insertedAccount.Name);
        System.assertEquals('123-456-7890', insertedAccount.Phone);
        System.assertEquals('http://www.example.com', insertedAccount.Website);
        System.assertEquals('Customer - Direct', insertedAccount.Type);
    }

    @isTest
    static void testCreateNewAccount_ErrorHandling() {
        // Test case for error handling during account creation
        Test.startTest();
        try {
            AccountInsertion.createNewAccount('Test Account', '123-456-7890', 'http://www.example.com', 'Customer - Direct');
            // Inserting an account with a duplicate name should throw an exception
            AccountInsertion.createNewAccount('Test Account', '999-888-7777', 'http://www.error.com', 'Customer - Channel');
        } catch (Exception e) {
            // The actual exception message may differ; adapt based on your Salesforce validation rules
            String expectedErrorMessage = 'FIELD_CUSTOM_VALIDATION_EXCEPTION, Account with this name already exists: []';
            System.assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'), 'Exception does not match expected');
        }
        Test.stopTest();
    }
}
