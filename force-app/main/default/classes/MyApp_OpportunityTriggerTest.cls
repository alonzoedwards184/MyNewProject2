@isTest
private class myapp_OpportunityTriggerTest {
    @isTest static void testMyApp_OpportunityTrigger() {
        // Reset the static variable
        myapp_OpportunityTrigger_Test.hasExecuted = false;
        
        // Capture the current time
        Datetime testStartTime = Datetime.now();
        
        // Create test Account
        Account testAccount = new Account();
        testAccount.Name = 'Test Account';
        insert testAccount;
        
        // Wait for trigger to complete
        Test.startTest();
        Test.stopTest();
        
        // Verify Opportunity creation
        List<Opportunity> opportunities = [SELECT Id, Name, StageName, CloseDate FROM Opportunity WHERE AccountId = :testAccount.Id];
        System.assertEquals(1, opportunities.size(), 'Expected one Opportunity to be created.');
        
        Opportunity createdOpp = opportunities[0];
        System.assertEquals('Great Opportunity', createdOpp.Name, 'Incorrect Opportunity name');
        System.assertEquals('Prospecting', createdOpp.StageName, 'Incorrect Opportunity stage');
        
        // Verify Task creation
        List<Task> tasks = [SELECT Id, Subject, WhatId FROM Task WHERE WhatId = :testAccount.Id AND CreatedDate >= :testStartTime];
        System.assertEquals(1, tasks.size(), 'Expected one Task to be created.');
        
        Task createdTask = tasks[0];
        System.assertEquals('Make sure you get contact information', createdTask.Subject, 'Incorrect Task subject');
    }
}
