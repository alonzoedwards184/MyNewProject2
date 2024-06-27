trigger CreateTaskOnAccountInsert on Account (after insert) {
    List<Task> newTasks = new List<Task>();

    for (Account newAccount : Trigger.new) {
        // Create a Task related to the new Account
        Task task = new Task();
        task.Subject = 'Follow Up';
        task.Description = 'Follow up with new account ' + newAccount.Name;
        task.WhatId = newAccount.Id; // Link Task to the Account
        task.Priority = 'Normal';
        task.Status = 'Not Started';

        newTasks.add(task);
    }

    // Insert all new Tasks created
    if (!newTasks.isEmpty()) {
        insert newTasks;
    }
}
