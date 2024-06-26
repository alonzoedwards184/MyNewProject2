@isTest
public class LeadTriggerTest {

    @isTest
    static void testLeadTrigger() {
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            Status = 'New'
        );
        insert testLead;

        List<Task> tasks = [SELECT Id, WhatId, Subject FROM Task WHERE WhatId = :testLead.Id];

        System.assertEquals(1, tasks.size(), 'Expected one Task to be created');
        System.assertEquals(testLead.Id, tasks[0].WhatId, 'Task should be related to the Lead');
    }
}
