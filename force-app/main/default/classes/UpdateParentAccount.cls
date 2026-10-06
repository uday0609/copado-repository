public class UpdateParentAccount implements Queueable {
    
    private List<Account> accList;
    private Id parentAccountId;
    
    public UpdateParentAccount(List<Account> accList, Id parentAccountId){
        this.accList = accList;
        this.parentAccountId = parentAccountId;
    }
    
    public void execute(QueueableContext qc){
        for(Account acc : accList){
            acc.ParentId = parentAccountId;
        }
        update accList;
    }
}