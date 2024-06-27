public class LeadInsertion {
    public static void createNewLead(String leadName, String leadCompany) {
        Lead newLead = new Lead();

        newLead.LastName = leadName;
        newLead.Company = leadCompany;

        try {
            insert newLead;
            System.debug('New Lead created with Name: ' + newLead.LastName);
        } catch (Exception e) {
            System.debug('Error creating new Lead: ' + e.getMessage());
        }
    }
}
