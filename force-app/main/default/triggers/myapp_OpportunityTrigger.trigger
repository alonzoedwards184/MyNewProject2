trigger myapp_OpportunityTrigger on Opportunity (after insert, after update) {
    // List to hold new Tasks to be inserted
    List<Task> newTasks = new List<Task>();

    // Map to hold Account Id to Account Name
    Map<Id, Account> accountMap = new Map<Id, Account>();

    // Get all related Accounts
    for (Opportunity opp : Trigger.new) {
        if (opp.AccountId != null) {
            accountMap.put(opp.AccountId, null);
        }
    }
    
    // Query Accounts
    if (!accountMap.isEmpty()) {
        accountMap.putAll([SELECT Id, Name FROM Account WHERE Id IN :accountMap.keySet()]);
    }

    // Iterate through all Opportunities in trigger context
    for (Opportunity opp : Trigger.new) {
        // Check if Opportunity Probability is 90% or higher
        if (opp.Probability >= 90) {
            // Create a new Task for follow-up
            Task newTask = new Task();
            newTask.Subject = 'We are getting close!';
            newTask.Description = 'Follow up with new account ' + (accountMap.containsKey(opp.AccountId) ? accountMap.get(opp.AccountId).Name : 'Unknown');
            newTask.Priority = 'High';
            newTask.WhatId = opp.Id; // Link the Task to the Opportunity

            // Add Task to the list for bulk insert
            newTasks.add(newTask);
        }
    }

    // Insert all new Tasks created
    if (!newTasks.isEmpty()) {
        insert newTasks;
    }
}
