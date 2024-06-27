public class LeadInsertion {
    public static void createNewLead(String leadName, String leadCompany ){
        Lead newLead = new Lead();

        newLead.LastName;
        newLead.Company;

        try {
            insert newLead;
            System.debug('New Account created with Name: ' + newLead.LastName);
        } catch (Exception e) {
            System.debug('Error creating new Lead: ' + e.getMessage());
        }

    }


}