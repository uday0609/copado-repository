public class OpportunityTriggerHandler {
    
    public static Set<Id> visitedOpportunity = new Set<Id>();
    
    public static void beforeInsert(List<Opportunity> oppList){
       // OpportunityHelper.updateStageType(oppList);
       //OpportunityHelper.restrictAccountStageProgress(oppList, null);
       //OpportunityHelper.preventDuplicateOpportunity(oppList);
    	//OpportunityHelper.preventOrDeleteLowStageOpportunity(oppList);
    }

    public static void afterInsert(List<Opportunity> oppList){
        //OpportunityHelper.findHighestAndLowestSalaryOfOpportunity(oppList);
        //OpportunityHelper.createTaskOnOpportunity(oppList);
        //OpportunityHelper.updateAccountTotalRevenue(oppList, null);
        //OpportunityHelper.restrictAccountStageProgress(oppList, null);
        //OpportunityHelper.splitOpportunity(oppList, null);
        //OpportunityHelper.calculateRevenueRollup(oppList, null);
        OpportunityHelper.opportunityRevenueRecalculate(oppList, null);
    }

    public static void afterUpdate(List<Opportunity> oppList, Map<Id,Opportunity> oldMap){
        // OpportunityHelper.updateDescription(oppList, oldMap);
        //OpportunityHelper.findHighestAndLowestSalaryOfOpportunityOnUpdate(oppList,oldMap);
        //OpportunityHelper.createTaskOnOpportunity(oppList);
    	//OpportunityHelper.updateAccountTotalRevenue(oppList, oldMap);
    	//OpportunityHelper.maintainOpportunityStageHistory(oppList,oldMap);
    	//OpportunityHelper.restrictAccountStageProgress(oppList, oldMap);
    	//OpportunityHelper.splitOpportunity(oppList, oldMap);
    	//OpportunityHelper.calculateRevenueRollup(oppList, oldMap);
    	OpportunityHelper.opportunityRevenueRecalculate(oppList, oldMap);
    }
    

    public static void afterDelete(List<Opportunity> oppList){
      //OpportunityHelper.findHighestAndLowestSalaryOfOpportunityOnDelete(oldMap);
      //OpportunityHelper.calculateRevenueRollup(oppList,null);
    }
    
    public static void beforeUpdate(List<Opportunity> oppList, Map<Id,Opportunity> oldMap){
    	//OpportunityHelper.preventClosingOpportunity(oppList,oldMap);
    	//OpportunityHelper.preventChangingOpportunity(oppList,oldMap);
    	//OpportunityHelper.preventOrDeleteLowStageOpportunity(oppList);
    	//OpportunityHelper.preventOpportunityDowngrade(oppList, oldMap);
    }
    
    public static void beforeDelete(List<Opportunity> oppList){
        //OpportunityHelper.preventOpportunityDeletion(oppList);
    }
}