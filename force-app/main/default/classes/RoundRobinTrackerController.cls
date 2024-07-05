public with sharing class RoundRobinTrackerController {
    
    @AuraEnabled(cacheable=true)
    public static List<User> getUsers() {
        return [SELECT Id, Name FROM User WHERE IsActive = true LIMIT 10]; // Example query to fetch active users
    }

    @AuraEnabled
    public static Id getNextAssignee() {
        List<Round_Robin_Tracker__c> trackers = [SELECT Id, Current_Assignee__c, Order__c FROM Round_Robin_Tracker__c ORDER BY Order__c ASC];

        if (trackers.isEmpty()) {
            throw new AuraHandledException('No assignees available for round robin assignment.');
        }

        // Find the next assignee based on round robin logic
        Round_Robin_Tracker__c nextTracker = trackers[0];

        // Move the current assignee to the end of the list (circular logic)
        for (Integer i = 1; i < trackers.size(); i++) {
            if (trackers[i].Order__c > nextTracker.Order__c) {
                nextTracker = trackers[i];
                break;
            }
        }

        return nextTracker.Current_Assignee__c;
    }
}
