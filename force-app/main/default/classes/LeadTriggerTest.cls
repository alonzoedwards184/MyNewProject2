@isTest
public class LeadTriggerTest {
    
    // Test method to insert Lead records and verify Task creation
    @isTest
    static void testLeadTrigger() {
        // Create test data - Lead records
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
        insert testLeads; // Insert the test Lead records
        
        // Verify Task creation for each inserted Lead
        List<Task> insertedTasks = [SELECT Id, WhatId, Subject, Status, Priority FROM Task WHERE WhatId IN :testLeads];
        System.assertEquals(testLeads.size(), insertedTasks.size(), 'Number of Tasks created should match number of Leads inserted');
        
        // Additional assertions can be added to verify Task details if needed
        for (Task t : insertedTasks) {
            System.assertEquals('Follow up on new lead', t.Subject, 'Task subject should be "Follow up on new lead"');
            System.assertEquals('Not Started', t.Status, 'Task status should be "Not Started"');
            System.assertEquals('Normal', t.Priority, 'Task priority should be "Normal"');
        }
    }
}
