@IsTest
public class MyApp_OpportunityTriggerTest {
    @IsTest
    static void testOpportunityTrigger() {
        // Create a test Account
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        // Create a test Opportunity with Probability less than 90%
        Opportunity oppLowProbability = new Opportunity(
            Name = 'Low Probability Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            Probability = 50,
            AccountId = testAccount.Id
        );
        insert oppLowProbability;

        // Verify that no Task is created
        List<Task> tasks = [SELECT Id FROM Task WHERE WhatId = :oppLowProbability.Id];
        System.assertEquals(0, tasks.size(), 'No tasks should be created for opportunities with probability less than 90%');

        // Create a test Opportunity with Probability 90%
        Opportunity oppHighProbability = new Opportunity(
            Name = 'High Probability Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            Probability = 90,
            AccountId = testAccount.Id
        );
        insert oppHighProbability;

        // Verify that a Task is created
        tasks = [SELECT Id, Subject, Description, Priority, WhatId FROM Task WHERE WhatId = :oppHighProbability.Id];
        System.assertEquals(1, tasks.size(), 'A task should be created for opportunities with probability 90% or higher');
        Task createdTask = tasks[0];
        System.assertEquals('We are getting close!', createdTask.Subject);
        System.assertEquals('Follow up with new account Test Account', createdTask.Description);
        System.assertEquals('High', createdTask.Priority);

        // Update the test Opportunity to increase Probability
        oppHighProbability.Probability = 95;
        update oppHighProbability;

        // Verify that another Task is not created (as it already exists for this Opportunity)
        tasks = [SELECT Id FROM Task WHERE WhatId = :oppHighProbability.Id];
        System.assertEquals(1, tasks.size(), 'No additional task should be created on opportunity update');
    }
}
