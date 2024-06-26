@isTest
public class LeadTriggerTest {

    @isTest
    static void testLeadTrigger() {
        // Create test Lead records
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            Status = 'New'
        );
        insert testLead; // Insert test Lead record

        // Query inserted Lead (optional)
        testLead = [SELECT Id FROM Lead WHERE Id = :testLead.Id];

        // Query Tasks created by the trigger
        List<Task> tasks = [SELECT Id, WhatId, Subject FROM Task WHERE WhatId = :testLead.Id];

        // Assert that a Task was created for the Lead
        System.assertEquals(1, tasks.size(), 'Expected one Task to be created');
        System.assertEquals(testLead.Id, tasks[0].WhatId, 'Task should be related to the Lead');
    }
}
