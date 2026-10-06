public class QuoteTriggerHandler {
    public static void changeSalesTaxLookup(List<Quote> quoteList,Map<Id,Quote> oldMap){
        Set<String> state = new Set<String>();
        Set<String> city = new Set<String>();
        
        for(Quote quote : quoteList){
            if(quote.BillingState != null ||(oldMap != null && quote.BillingState != oldMap.get(quote.Id).BillingState)){
                state.add(quote.BillingState);
            }
            if(quote.BillingCity != null || (oldMap != null && quote.BillingCity != oldMap.get(quote.Id).BillingCity)){
                city.add(quote.BillingCity);
            }
        }
        
        Map<String,Id> salesTaxMap = new Map <String,Id>();
        for(Sales_Tax__c  sales : [SELECT Id,State__c,City__c FROM Sales_Tax__c WHERE State__c IN: state AND City__c IN: city ] ){
            salesTaxMap.put(sales.State__c + ' |'+ sales.City__c, sales.Id);
        }
        
        for(Quote quote : quoteList){
            if(salesTaxMap.containsKey(quote.BillingState + ' |' + quote.BillingCity)){ 
                quote.Sales_Tax__c = salesTaxMap.get(quote.BillingState + ' |' + quote.BillingCity); 
            }
            else{
                quote.Sales_Tax__c = null;
            }
        }
    }  
}