@isTest
public class LeadTriggerTest {

    @isTest
    static void testLeadTrigger() {
        // Create test Lead record
        Lead testLead = new Lead(
            FirstName = 'John',
            LastName = 'Doe',
            Company = 'Test Company',
            Status = 'New'
        );

        // Insert the Lead record
        Test.startTest(); // Start test context
        insert testLead;
        Test.stopTest(); // Stop test context

        // Optionally, add assertions if needed
        // For instance, check if the Lead was inserted successfully
        Lead insertedLead = [SELECT Id, FirstName, LastName, Company, Status FROM Lead WHERE Id = :testLead.Id];
        System.assertEquals('New', insertedLead.Status, 'Expected Lead status to be New');
    }
}
