trigger OpportunityTrigger on Opportunity (after insert) {
    // Collect all newly inserted Opportunity Ids
    Set<Id> newOpportunityIds = new Set<Id>();
    for (Opportunity opp : Trigger.new) {
        newOpportunityIds.add(opp.Id);
    }
    
    // Query the newly inserted Opportunities to update their owner
    List<Opportunity> newOpportunities = [SELECT Id, OwnerId FROM Opportunity WHERE Id IN :newOpportunityIds];
    
    // Iterate over each Opportunity and update its owner using the controller method
    for (Opportunity opp : newOpportunities) {
        OpportunityController.updateOpportunityOwner(opp.Id, opp.OwnerId, 1); // Assuming newOrder as 1 for example
    }
}
