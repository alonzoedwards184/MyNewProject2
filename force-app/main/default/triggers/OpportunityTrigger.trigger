trigger OpportunityTrigger on Opportunity (before insert) {
    // Ensure trigger only fires on before insert
    if (Trigger.isBefore && Trigger.isInsert) {
        // Call handler class method to assign owners
        OpportunityController.AssignOwner(Trigger.new);
    }
}
