public with sharing class OpportunityController {

    @AuraEnabled
    public static void updateOpportunityOwner(Id opportunityId, Id newOwnerId, Integer newOrder) {
        try {
            Opportunity opp = [SELECT Id, OwnerId FROM Opportunity WHERE Id = :opportunityId];
            opp.OwnerId = newOwnerId;
            update opp;
            
            // Update Round Robin Tracker record with new order
            Round_Robin_Tracker__c roundRobinRecord = [
                SELECT Id 
                FROM Round_Robin_Tracker__c 
                WHERE Current_Assignee__c = :newOwnerId
                ORDER BY Last_Assigned_Date__c DESC
                LIMIT 1
            ];
            if (roundRobinRecord != null) {
                roundRobinRecord.Order__c = newOrder;
                update roundRobinRecord;
            }
        } catch (Exception e) {
            throw new AuraHandledException('Error updating Opportunity owner: ' + e.getMessage());
        }
    }
}
