public class OpportunityProductHandler {
    
    public static void checkPrimaryProduct(List<OpportunityProduct__c> oppProductList ,Map<Id,OpportunityProduct__c> oldMap){
        Set<Id> oppIds = new Set<Id>();
        for(OpportunityProduct__c oppProduct : oppProductList){
            if(oppProduct.Opportunity__c == null) continue;
            Boolean isInsert = oldMap == null;
            if(isInsert){
                if(oppProduct.Primary_Product__c){
                    oppIds.add(oppProduct.Opportunity__c);
                }
            }
            else{
                OpportunityProduct__c oldRec = oldMap.get(oppProduct.Id);
                if(oppProduct.Primary_Product__c && !oldRec.Primary_Product__c){
                    oppIds.add(oppProduct.Opportunity__c);
                }
            }
        }
        Map<Id,OpportunityProduct__c> existingPrimary = new Map<Id,OpportunityProduct__c>();
        for(OpportunityProduct__c prod :[SELECT Id,Opportunity__c,Primary_Product__c FROM OpportunityProduct__c WHERE Opportunity__c IN :oppIds AND Primary_Product__c = TRUE]){
            existingPrimary.put(prod.Opportunity__c, prod);
        }
        
        List<OpportunityProduct__c> oppProductUpdate = new List<OpportunityProduct__c>();
        for(OpportunityProduct__c oppProduct : oppProductList){
            if(oppProduct.Primary_Product__c == TRUE && existingPrimary.containsKey(oppProduct.Opportunity__c)){
                OpportunityProduct__c oldPrimary = existingPrimary.get(oppProduct.Opportunity__c);
                if(oldPrimary.Id != oppProduct.Id){
                    oldPrimary.Primary_Product__c = false;
                    oppProductUpdate.add(oldPrimary);
                }
            }
        }
        if(!oppProductUpdate.isEmpty()){
            update oppProductUpdate;
        }
        Set<Id> checkOpp = new Set<Id>();
        for(OpportunityProduct__c rec : oppProductList){
            if(rec.Opportunity__c != null && !rec.Primary_Product__c){
                checkOpp.add(rec.Opportunity__c);
            }
        }
        
        if(checkOpp.isEmpty()) return;
        Map<Id,Integer> productCount = new Map<Id,Integer>();
        for(AggregateResult ar :[SELECT Opportunity__c, COUNT(Id) total FROM OpportunityProduct__c WHERE Opportunity__c IN :checkOpp GROUP BY Opportunity__c]){
            productCount.put((Id)ar.get('Opportunity__c'), (Integer)ar.get('total'));
        }
   
        for(OpportunityProduct__c oppProduct : oppProductList){
            if(!oppProduct.Primary_Product__c && productCount.containsKey(oppProduct.Opportunity__c) && productCount.get(oppProduct.Opportunity__c) == 0){
                oppProduct.Primary_Product__c = true;
            }
        }
    }
}