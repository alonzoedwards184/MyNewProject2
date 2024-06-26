public class LeadInsertion {

    public static void insertLeads() {
        List<Lead> newLeads = new List<Lead>();

        // Create first lead
        Lead lead1 = new Lead(
            FirstName = 'John',
            LastName = 'Doe',
            Company = 'ABC Inc.',
            Status = 'New'
        );
        newLeads.add(lead1);

        // Create second lead
        Lead lead2 = new Lead(
            FirstName = 'Jane',
            LastName = 'Smith',
            Company = 'XYZ Corp.',
            Status = 'New'
        );
        newLeads.add(lead2);

        // Create third lead
        Lead lead3 = new Lead(
            FirstName = 'Michael',
            LastName = 'Johnson',
            Company = '123 Industries',
            Status = 'New'
        );
        newLeads.add(lead3);

        // Create fourth lead
        Lead lead4 = new Lead(
            FirstName = 'Emily',
            LastName = 'Brown',
            Company = 'Tech Solutions Ltd.',
            Status = 'New'
        );
        newLeads.add(lead4);

        // Insert all leads in a single DML operation
        insert newLeads;
    }
}
