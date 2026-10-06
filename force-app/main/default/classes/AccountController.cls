/**
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 * Class Name      : AccountController
 * Author          : <YourName>
 * Created Date    : May 4, 2026
 * Last Modified By: <YourName>
 * Last Modified On: May 4, 2026
 * Description     : This class implements for......
 *  
 * Change History  :
 *  Date          │   Author     │   Change
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 *  May 4, 2026  │ <YourName>   │ Initial version
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 */

public class AccountController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(){
        try{
            return [SELECT OwnerId,Name,Rating,ParentId,Phone,AccountNumber,Fax,Site,Website,TickerSymbol,Industry,Ownership,AnnualRevenue,NumberOfEmployees,Sic FROM Account];
        }
        catch(Exception e){
            throw new AuraHandledException('Error fetching accounts: ' + e.getMessage());
        }
    }
}