public class LeadInsertion {

    // Method to create a new Lead
    public static void createNewLead(String leadLastName, String leadCompany, String leadTitle) {
        // Instantiate a new Lead object
        Lead newLead = new Lead();

        // Set the Lead fields
        newLead.LastName = leadLastName;
        newLead.Company = leadCompany;
        newLead.Title = leadTitle;

        // Insert the new Lead record
        try {
            insert newLead;
            System.debug('New Lead created with Name: ' + newLead.LastName);
        } catch (Exception e) {
            System.debug('Error creating new Lead: ' + e.getMessage());
        }
    }
}
