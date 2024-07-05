trigger OpportunityTrigger on Opportunity (after insert) {
    // Query Round Robin Tracker records based on your criteria
    List<Round_Robin_Tracker__c> roundRobinTrackers = [
        SELECT Id, Order__c, Current_Assignee__c, Last_Assigned_Date__c
        FROM Round_Robin_Tracker__c
        WHERE IsActive__c = true  // Replace with your actual field API name for active status
        ORDER BY Order__c ASC
        LIMIT 1
    ];

    // Check if there's at least one active Round Robin Tracker record
    if (!roundRobinTrackers.isEmpty()) {
        Round_Robin_Tracker__c roundRobinTracker = roundRobinTrackers[0];

        // Update Opportunity records with the next available assignee and related fields
        List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();
        for (Opportunity opp : Trigger.new) {
            opp.OwnerId = roundRobinTracker.Current_Assignee__c;
            opportunitiesToUpdate.add(opp);
        }

        // Update the Order__c and Last_Assigned_Date__c fields in Round Robin Tracker record
        roundRobinTracker.Order__c = customMod(roundRobinTracker.Order__c + 1, roundRobinTrackers.size());
        roundRobinTracker.Last_Assigned_Date__c = DateTime.now();

        // Perform DML operations
        update opportunitiesToUpdate;
        update roundRobinTracker;
    } else {
        System.debug('No active Round Robin Tracker record found.');
        // Handle case where no active Round Robin Tracker record is found
        // You may throw an exception, log an error, or handle it according to your business logic
    }
}

