trigger myapp_OpportunityTrigger on Account (after insert) {
    List<Opportunity> opportunitiesToInsert = new List<Opportunity>();
    List<Task> tasksToInsert = new List<Task>();
    
    for (Account acc : Trigger.new) {
        // Create Opportunity
        Opportunity opp = new Opportunity();
        opp.Name = 'Great Opportunity';
        opp.StageName = 'Prospecting';
        opp.CloseDate = System.today().addDays(30);
        opp.AccountId = acc.Id;
        opportunitiesToInsert.add(opp);
        
        // Create Task
        Task task = new Task();
        task.Subject = 'Make sure you get contact information';
        task.WhatId = acc.Id;
        task.ActivityDate = System.today().addDays(15);
        tasksToInsert.add(task);
    }
    
    // Insert Opportunities and Tasks
    if (!opportunitiesToInsert.isEmpty()) {
        insert opportunitiesToInsert;
    }
    if (!tasksToInsert.isEmpty()) {
        insert tasksToInsert;

    }
}
