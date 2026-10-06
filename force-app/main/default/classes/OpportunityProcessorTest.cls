@isTest 
public class OpportunityProcessorTest {
    
    @isTest
    public static void testBatchClass(){
        List<Opportunity> oppList = new List<Opportunity>();
        
        for(Integer i=0; i<200; i++){
            oppList.add(new Opportunity(Name = 'Test' + i, StageName = 'Prospecting', CloseDate = System.today()));
        }
        insert oppList;
        Test.startTest();
        OpportunityProcessor oppProcess = new OpportunityProcessor();
        Id batchId = Database.executeBatch(oppProcess,200);
        Test.stopTest();
        
        List<Opportunity> updatedOpp =[SELECT Id FROM Opportunity WHERE LeadSource = 'Web'];
        System.assertEquals(200,updatedOpp.size());
    }
}