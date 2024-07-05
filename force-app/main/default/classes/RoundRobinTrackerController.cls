public with sharing class RoundRobinTrackerController {
    
    @AuraEnabled(cacheable=true)
    public static List<User> getUsers() {
        return [SELECT Id, Name FROM User WHERE IsActive = true];
    }
    
    @AuraEnabled
    public static Id createRoundRobinTrackerRecord(Integer nextOrder, Id currentAssignee) {
        try {
            // Check if a record already exists for the current assignee
            if (isDuplicateRecord(currentAssignee)) {
                throw new AuraHandledException('Record already exists for this assignee.');
            }
            
            // Create new record
            Round_Robin_Tracker__c newRecord = new Round_Robin_Tracker__c();
            newRecord.Order__c = nextOrder;
            newRecord.Current_Assignee__c = currentAssignee;
            newRecord.Last_Assigned_Date__c = DateTime.now();
            newRecord.Is_Active__c = True;
            
            insert newRecord;
            
            return newRecord.Id;
        } catch (Exception e) {
            throw new AuraHandledException('Error creating Round Robin Tracker record: ' + e.getMessage());
        }
    }
    
    // Helper method to check for duplicate records
    private static Boolean isDuplicateRecord(Id currentAssignee) {
        List<Round_Robin_Tracker__c> existingRecords = [
            SELECT Id 
            FROM Round_Robin_Tracker__c 
            WHERE Current_Assignee__c = :currentAssignee
        ];
        return !existingRecords.isEmpty();
    }
    
}
