trigger myapp_OpportunityTrigger on Opportunity (before insert, before update) {
    List<Task> newTasks = new List<Task>();
    Set<Id> accountIds = new Set<Id>();

    // Collect AccountIds from Opportunities
    for (Opportunity opp : Trigger.new) {
        accountIds.add(opp.AccountId);
    }

    // Query Accounts related to Opportunities
    Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, Name FROM Account WHERE Id IN :accountIds]);

    // Process Opportunities and create Tasks
    for (Opportunity opp : Trigger.new) {
        if (opp.Probability >= 90 && accountMap.containsKey(opp.AccountId)) {
            Task newTask = new Task();
            newTask.Subject = 'We are getting close!';
            newTask.Description = 'Follow up with new account ' + accountMap.get(opp.AccountId).Name;
            newTask.Priority = 'High';
            newTask.WhatId = opp.Id; // Link Task to the Opportunity

            newTasks.add(newTask);
        }
    }

    // Add Tasks to the Opportunities
    for (Opportunity opp : Trigger.new) {
        opp.Description = 'Created ' + newTasks.size() + ' task(s) for follow-up with account ' + accountMap.get(opp.AccountId).Name;
    }
}
