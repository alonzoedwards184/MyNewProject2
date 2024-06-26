trigger LeadTrigger on Lead (after insert) {
    List<Task> newTasks = new List<Task>();
    
    for (Lead newLead : Trigger.new) {
        Task newTask = new Task(
            WhatId = newLead.Id,  // Set WhatId to the Lead's ID
            Subject = 'Follow up on new lead',
            Status = 'Not Started',
            Priority = 'Normal'
        );
        newTasks.add(newTask);
    }
    
    insert newTasks;
}
