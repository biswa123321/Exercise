@isTest
public class RelatedObjectRecordsControllerTest {

    @isTest
    static void testGetRelatedRecords() {
        // Step 1: Create Test Data
        // Create a parent object (e.g., Account)
        Account parentAccount = new Account(Name = 'Test Parent Account');
        insert parentAccount;

        // Create child objects (e.g., Contacts) related to the parent account
        Contact contact1 = new Contact(FirstName = 'John', LastName = 'Doe', AccountId = parentAccount.Id);
        Contact contact2 = new Contact(FirstName = 'Jane', LastName = 'Doe', AccountId = parentAccount.Id);
        insert new List<Contact> { contact1, contact2 };

        // Step 2: Define parameters for the method call
        Id parentRecordId = parentAccount.Id;
        String childObjectApiName = 'Contact';
        String relationshipFieldName = 'AccountId';
        String fieldSetName = 'FS'; 

        // Step 3: Start the test context
        Test.startTest();

        // Step 4: Call the method and capture the results
        List<SObject> relatedRecords = RelatedObjectRecordsController.getRelatedRecords(parentRecordId, childObjectApiName, relationshipFieldName, fieldSetName);

        // Step 5: End the test context
        Test.stopTest();

        // Step 6: Assertions to validate the behavior
        System.assertEquals(2, relatedRecords.size(), 'There should be 2 related contacts.');
    }
}