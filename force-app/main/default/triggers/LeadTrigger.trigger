trigger LeadTrigger on Lead (after insert) {
    for (Lead lead : Trigger.new) {
        Task newTask = new Task(
            WhatId = lead.Id,
            Subject = 'Follow up on new lead',
            Status = 'Not Started',
            Priority = 'Normal'
        );
        insert newTask;
    }
}
