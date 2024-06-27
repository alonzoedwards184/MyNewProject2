public class AccountInsertion {

    // Method to create a new Account
    public static void createNewAccount(String accName, String accPhone, String accWebsite) {
        // Instantiate a new Account object
        Account newAccount = new Account();

        // Set the Account fields
        newAccount.Name = accName;
        newAccount.Phone = accPhone;
        newAccount.Website = accWebsite;

        // Insert the new Account record
        try {
            insert newAccount;
            System.debug('New Account created with Name: ' + newAccount.Name);
        } catch (Exception e) {
            System.debug('Error creating new Account: ' + e.getMessage());
        }
    }
}
