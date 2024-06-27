@IsTest
public class MyApp_OpportunityTriggerTest {
    @IsTest
    static void testOpportunityTrigger() {
        // Create a test Account
        Account testAccount = new Account(Name = 'Test Account', Phone = '000-000-0000');
        insert testAccount; // Insert the Account

        // Create a test Opportunity with Probability less than 90%
        Opportunity oppLowProbability = new Opportunity(
            Name = 'Low Probability Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            Probability = 50,
            AccountId = testAccount.Id
        );
        insert oppLowProbability; // Insert the Opportunity with low probability

        // Verify that no Task is created
        List<Task> tasksLowProb = [SELECT Id FROM Task WHERE WhatId = :oppLowProbability.Id];
        System.assertEquals(0, tasksLowProb.size(), 'No tasks should be created for opportunities with probability less than 90%');

        // Create a test Opportunity with Probability 90%
        Opportunity oppHighProbability = new Opportunity(
            Name = 'High Probability Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            Probability = 90,
            AccountId = testAccount.Id
        );
        insert oppHighProbability; // Insert the Opportunity with high probability

        // Verify that a Task is created
        List<Task> tasksHighProb = [SELECT Id, Subject, Description, Priority, WhatId FROM Task WHERE WhatId = :oppHighProbability.Id];
        System.assertEquals(1, tasksHighProb.size(), 'A task should be created for opportunities with probability 90% or higher');
        Task createdTask = tasksHighProb[0];
        System.assertEquals('We are getting close!', createdTask.Subject);
        System.assertEquals('Follow up with new account Test Account', createdTask.Description);
        System.assertEquals('High', createdTask.Priority);

        // Update the test Opportunity to increase Probability
        oppHighProbability.Probability = 95;
        update oppHighProbability; // Update the Opportunity

        // Verify that no additional Task is created on update
        List<Task> updatedTasks = [SELECT Id FROM Task WHERE WhatId = :oppHighProbability.Id];
        System.assertEquals(1, updatedTasks.size(), 'No additional task should be created on opportunity update');
    }
}
