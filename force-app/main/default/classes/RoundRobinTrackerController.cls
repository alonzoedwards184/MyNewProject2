public with sharing class RoundRobinTrackerController {
    
    @AuraEnabled(cacheable=true)
    public static List<User> getUsers() {
        return [SELECT Id, Name FROM User WHERE IsActive = true LIMIT 10]; // Example query to fetch active users
    }
}
