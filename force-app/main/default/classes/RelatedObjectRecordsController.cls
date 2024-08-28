public with sharing class RelatedObjectRecordsController {
        
    @AuraEnabled(cacheable=true)
        public static List<SObject> getRelatedRecords(Id parentRecordId, String childObjectApiName, String relationshipFieldName, String fieldSetName) {
            // Check for null parameters
            if (parentRecordId == null || childObjectApiName == null || relationshipFieldName == null || fieldSetName == null) {
                throw new AuraHandledException('Missing required parameters.');
            }
    
            // Get the fields from the field set
            System.debug('fieldSetName=='+fieldSetName);
            System.debug('parentRecordId==='+parentRecordId);
                
            Schema.FieldSet fieldSet = Schema.getGlobalDescribe().get(childObjectApiName).getDescribe().FieldSets.getMap().get(fieldSetName);
            List<String> fieldSetFields = new List<String>();
            for (Schema.FieldSetMember f : fieldSet.getFields()) {
                fieldSetFields.add(f.getFieldPath());
            }
    
            // Build dynamic SOQL query
            String queryString = 'SELECT ' + String.join(fieldSetFields, ', ') +
                             ' FROM ' + childObjectApiName +
                             ' WHERE ' + relationshipFieldName + ' = \'' + parentRecordId + '\'';
             System.debug('queryString==='+queryString);                     
    
            // Execute the query in user mode
            return Database.query(queryString);
    }
}
    