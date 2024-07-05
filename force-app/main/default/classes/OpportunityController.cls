public class OpportunityController {

    public static void AssignOwner(List<Opportunity> Opps) {
        List<Round_Robin_Tracker__c> SARAssignees = [SELECT Current_Assignee__c, Last_Assigned_Date__c
                                                     FROM Round_Robin_Tracker__c
                                                     WHERE Current_Assignee__r.isActive = True 
                                                     ORDER BY Last_Assigned_Date__c ASC, Order__c ASC];

        if (!SARAssignees.isEmpty()) {
            List<Round_Robin_Tracker__c> RRAssigneesToUpdate = new List<Round_Robin_Tracker__c>();
            Integer CSRindex = 0;

            for (Opportunity opp : Opps) {
                Round_Robin_Tracker__c RRAssignee = SARAssignees.get(Math.mod(CSRindex, SARAssignees.size()));
                opp.OwnerId = RRAssignee.Current_Assignee__c;

                RRAssignee.Last_Assigned_Date__c = System.now();

                RRAssigneesToUpdate.add(RRAssignee);
                CSRindex++;
            }

            update RRAssigneesToUpdate;
        }
    }
}
