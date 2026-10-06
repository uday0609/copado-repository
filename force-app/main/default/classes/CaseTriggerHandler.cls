public class CaseTriggerHandler {
    public static void beforeInsert(List<Case> caseList){
    	//CaseHelper.validateCasePriority(caseList);
    }
    
    public static void beforeUpdate(List<Case> caseList,Map<Id,Case> oldMap){
        //CaseHelper.validateCasePriority(caseList);
    }
    
    public static void afterInsert(List<Case> caseList , Map<Id,Case> oldMap){
        //CaseHelper.setCountOnOpportunity(caseList , oldMap);
        CaseHelper.checkCasePriority(caseList, null);
    }	
    
    public static void afterUpdate(List<Case> caseList,Map<Id,Case>oldMap){
    	//CaseHelper.updatingTotalEscalation(caseList, oldMap);
    	CaseHelper.checkCasePriority(caseList,oldMap);  
    }
    
    public static void afterDelete(List<Case> caseList){
        CaseHelper.checkCasePriority(caseList, null);
    }
}