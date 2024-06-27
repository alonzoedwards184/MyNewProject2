@IsTest
public class MyApp_OpportunityTriggerTest {
    static void testOpportunityTrigger() {
        // Create a test Account
        Account testAccount = new Account(Name = 'Test Account', Phone = '000-000-0000');

        try {
            insert testAccount;
        } catch (DmlException e) {
            System.debug('An error occurred while inserting the test Account: ' + e.getMessage());
            System.assert(false, 'Failed to insert test Account: ' + e.getMessage());
        }

        // Create a test Opportunity with Probability less than 90%
        Opportunity oppLowProbability = new Opportunity(
            Name = 'Low Probability Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            Probability = 50,
            AccountId = testAccount.Id
        );

        try {
            insert oppLowProbability;
        } catch (DmlException e) {
            System.debug('An error occurred while inserting the low probability Opportunity: ' + e.getMessage());
            System.assert(false, 'Failed to insert low probability Opportunity: ' + e.getMessage());
        }

        // Verify that no Task is created
        List<Task> tasks = [SELECT Id FROM Task WHERE WhatId = :oppLowProbability.Id];
        System.assertEquals(0, tasks.size(), 'No tasks should be created for opportunities with probability less than 90%');

        // Update the test Opportunity to increase Probability
        oppLowProbability.Probability = 95;
        
        try {
            update oppLowProbability;
        } catch (DmlException e) {
            System.debug('An error occurred while updating the low probability Opportunity: ' + e.getMessage());
            System.assert(false, 'Failed to update low probability Opportunity: ' + e.getMessage());
        }

        // Verify that no additional Task is created (as it already exists for this Opportunity)
        tasks = [SELECT Id FROM Task WHERE WhatId = :oppLowProbability.Id];
        System.assertEquals(0, tasks.size(), 'No additional task should be created on opportunity update');
    }
}
