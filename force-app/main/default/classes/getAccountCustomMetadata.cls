public with sharing class getAccountCustomMetadata {
    
    @AuraEnabled(cacheable=true)
    public static List<HeaderFieldWrapper> getAccountHeaderFields(Id accountId) {
        List<HeaderFieldWrapper> headerFields = new List<HeaderFieldWrapper>();
        
        if (accountId == null) {
            return headerFields;
        }
        
        try {
            List<Account__mdt> metadataRecords = [SELECT Label, DeveloperName FROM Account__mdt WITH SECURITY_ENFORCED];
            System.debug('11-------------------------------- Metadata Records: ' + metadataRecords);
            Map<String, String> fieldToLabelMap = new Map<String, String>();
            List<String> fieldsToQuery = new List<String>();
            for (Account__mdt mdt : metadataRecords) {
                fieldsToQuery.add(mdt.DeveloperName);
                fieldToLabelMap.put(mdt.DeveloperName, mdt.Label);
            }
            System.debug('19----------------------------- Fields to Query: ' + fieldsToQuery);
            if (fieldsToQuery.isEmpty()) {
                return headerFields;
            }
            String queryString = 'SELECT Id';
            for (String field : fieldsToQuery) {
                queryString += ', ' + field.trim(); 
            }
            queryString += ' FROM Account WHERE Id = :accountId LIMIT 1';
            System.debug('29-------------------------------------------- Query: ' + queryString);
            List<Account> accList = Database.query(queryString);
            if (!accList.isEmpty()) {
                Account acc = accList[0];
                for (String field : fieldsToQuery) {
                    HeaderFieldWrapper wrapper = new HeaderFieldWrapper();
                    wrapper.id = field; 
                    wrapper.label = fieldToLabelMap.get(field); 
                    wrapper.value = acc.get(field) != null ? String.valueOf(acc.get(field)) : '';
                    headerFields.add(wrapper);
                }
            }
        } 
        catch (Exception e) {
            System.debug('Error in Metadata Fetch: ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
        return headerFields;
    }

    @AuraEnabled(cacheable=true)
    public static List<DatatableColumnWrapper> getDynamicColumns(String accountId, String tabId) {
        List<DatatableColumnWrapper> columnsList = new List<DatatableColumnWrapper>();
        
        if (String.isBlank(tabId)) {
            return columnsList;
        }

        String targetObject = tabId;
        List<AccountRelatedRecords__mdt> metadataRecords = [SELECT Id, Fields__c, RelatedObject__c FROM AccountRelatedRecords__mdt WHERE RelatedObject__c = :tabId];
        
         if (!metadataRecords.isEmpty()) {
            List<String> fieldApiNames = new List<String>();
            for(AccountRelatedRecords__mdt rec : metadataRecords) {
                if(String.isNotBlank(rec.Fields__c)) {
                    fieldApiNames.add(rec.Fields__c.trim());
                }
            }
            Map<String, Schema.SObjectField> objectFieldsMap = Schema.getGlobalDescribe().get(targetObject).getDescribe().fields.getMap();
            for(String fieldApiName : fieldApiNames) {
                String cleanField = fieldApiName.trim();
                if(objectFieldsMap.containsKey(cleanField)) {
                    Schema.DescribeFieldResult fieldDescribe = objectFieldsMap.get(cleanField).getDescribe();
                    String columnType = 'text';
                    columnsList.add(new DatatableColumnWrapper(fieldDescribe.getLabel(),cleanField,columnType));
                }
            }
        }
        return columnsList;
    }

    public class HeaderFieldWrapper {
        @AuraEnabled public String id { get; set; }
        @AuraEnabled public String label { get; set; }
        @AuraEnabled public String value { get; set; }
    }

   public class DatatableColumnWrapper {
        @AuraEnabled public String label { get; set; }
        @AuraEnabled public String fieldName { get; set; }
        @AuraEnabled public String type { get; set; }

        public DatatableColumnWrapper(String label, String fieldName, String type) {
            this.label = label;
            this.fieldName = fieldName;
            this.type = type;
        }
    }
}