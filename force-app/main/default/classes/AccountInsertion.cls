public class AccountInsertion {
    public static void createNewAccount(String accName, String accPhone, String accWebsite) {
        Account newAccount = new Account();

        newAccount.Name = accName;
        newAccount.Phone = accPhone;
        newAccount.Website = accWebsite;

        try {
            insert newAccount;
            System.debug('New Account created with Name: ' + newAccount.Name);
        } catch (Exception e) {
            System.debug('Error creating new Account: ' + e.getMessage());
        }
    }
}