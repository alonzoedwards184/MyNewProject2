// RoundRobinAssigner.cls

public with sharing class RoundRobinAssigner {

    @AuraEnabled(cacheable=true)
    public static RoundRobinResult getNextAssignee() {
        RoundRobinResult result = new RoundRobinResult();

        // Query the maximum order number from existing Round_Robin_Tracker__c records
        Integer maxOrder = getMaxOrderNumber();

        // Calculate the next order number
        result.order = maxOrder + 1;

        // Example assignee logic (replace with your actual logic)
        result.assigneeId = UserInfo.getUserId(); // Assign to the current user for illustration

        return result;
    }

    // Method to get the maximum order number from existing records
    private static Integer getMaxOrderNumber() {
        Integer maxOrder = 1; // Default starting order number

        // Query for the maximum order number from Round_Robin_Tracker__c records
        List<Round_Robin_Tracker__c> existingRecords = [SELECT Order__c FROM Round_Robin_Tracker__c ORDER BY Order__c DESC LIMIT 1];

        if (!existingRecords.isEmpty()) {
            maxOrder = existingRecords[0].Order__c.intValue(); // Convert Decimal to Integer
        }

        return maxOrder;
    }

    // Inner class to hold result data
    public class RoundRobinResult {
        @AuraEnabled
        public Integer order;
        @AuraEnabled
        public Id assigneeId;
    }
}
