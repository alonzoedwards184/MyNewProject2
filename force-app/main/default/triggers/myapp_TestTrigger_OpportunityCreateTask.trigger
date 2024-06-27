@isTest
private class myapp_TestTrigger_OpportunityCreateTask {
    static testMethod void testTrigger_OpportunityCreateTask() {
        // Create a test opportunity
        Opportunity testOpp = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today(),
            Probability = 90
        );
        insert testOpp;

        // Query the created task
        List<Task> createdTasks = [SELECT Id, Subject, Description, Priority FROM Task WHERE WhatId = :testOpp.Id];

        // Verify the task was created
        System.assertEquals(1, createdTasks.size(), 'Expected one task to be created');
        Task createdTask = createdTasks[0];
        System.assertEquals('We are getting close!', createdTask.Subject, 'Subject does not match expected');
        System.assertEquals('Follow up with new account Test Opportunity', createdTask.Description, 'Description does not match expected');
        System.assertEquals('High', createdTask.Priority, 'Priority does not match expected');
    }
}
