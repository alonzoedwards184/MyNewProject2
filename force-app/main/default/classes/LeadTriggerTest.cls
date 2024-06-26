@isTest
public class LeadTriggerTest {

    @isTest
    static void testLeadTrigger() {
        // Create test Lead records
        List<Lead> testLeads = new List<Lead>();
        for (Integer i = 0; i < 5; i++) {
            Lead l = new Lead(
                FirstName = 'Test',
                LastName = 'Lead ' + i,
                Company = 'Test Company ' + i,
                Status = 'New'
            );
            testLeads.add(l);
        }
        insert testLeads; // Insert test Lead records

        // Query inserted Leads (example)
        List<Lead> insertedLeads = [SELECT Id, FirstName, LastName FROM Lead WHERE Id IN :testLeads];

        // Example assertion
        System.assertEquals(testLeads.size(), insertedLeads.size(), 'Number of inserted Leads should match');

        // Additional test logic goes here
    }
}
