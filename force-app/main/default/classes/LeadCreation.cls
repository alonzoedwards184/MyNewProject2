public class LeadCreation {
    public static void createNewLead(String leadName, String leadCompany, String leadTitle) {
        Lead newLead = new Lead();

        newLead.LastName = leadName;
        newLead.Company = leadCompany;
        newLead.Title = leadTitle;

        try {
            insert newLead;
            System.debug('New Lead created with Name: ' + newLead.LastName);
        } catch (Exception e) {
            System.debug('Error creating new Lead: ' + e.getMessage());
        }
    }
}
