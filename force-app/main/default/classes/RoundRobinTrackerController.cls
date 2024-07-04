public with sharing class RoundRobinTrackerController {
    @AuraEnabled(cacheable=true)
    public static List<User> getGroupMembers(String groupId) {
        List<GroupMember> groupMembers = [SELECT UserOrGroupId FROM GroupMember WHERE GroupId = :groupId];
        Set<Id> userIds = new Set<Id>();
        for (GroupMember member : groupMembers) {
            userIds.add(member.UserOrGroupId);
        }
        return [SELECT Id, Name FROM User WHERE Id IN :userIds];
    }
}
