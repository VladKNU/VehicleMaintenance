public class CaseTriggerHandler {

    public static void preventUpdatingClosedCase(List<Case> newCases, Map<Id,Case> oldCases){    
        for(Case caseToUpdate : newCases){
            Case oldCase = oldCases.get(caseToUpdate.Id);

            if(oldCase.Satisfaction_Rating__c == caseToUpdate.Satisfaction_Rating__c && oldCase.Status == 'Closed'){
                caseToUpdate.addError('It is not possible to update a closed case.');
            }          
        }       
    }
    
    public static void updateAccountRatingAfterUpdate(List<Case> newCases, Map<Id,Case> oldCases){
        Set<Account> accountsToUpdate = new Set<Account>();
        Map<Id, Account> accounts = new Map<Id, Account>([
            SELECT Id, Rating__c, (SELECT Satisfaction_Rating__c FROM Cases WHERE Status = 'Closed') 
            FROM Account
            WHERE Id IN (SELECT AccountId FROM Case WHERE Id IN: newCases)
        ]);

        System.debug(accounts);

        for(Case caseToUpdate : newCases){
            Case oldCase = oldCases.get(caseToUpdate.Id);

            if(oldCase.Satisfaction_Rating__c != caseToUpdate.Satisfaction_Rating__c && oldCase.Status == 'Closed'){
                Account currentAccount = recalculateAccountRating(accounts.get(caseToUpdate.AccountId));
                accountsToUpdate.add(currentAccount);
            }   
        }

        update new List<Account>(accountsToUpdate);
    }

    public static void updateAccountRatingAfterDelete(Map<Id,Case> oldCases){
        
        Set<Account> accountsToUpdate = new Set<Account>();

        for(Account currentAccount : [
                SELECT Id, Rating__c, 
                (SELECT Id, Satisfaction_Rating__c FROM Cases WHERE Id NOT IN :oldCases.keySet() AND(Status = 'Closed')) 
                FROM Account 
                WHERE Id IN (SELECT AccountId FROM Case WHERE Id IN: oldCases.values())
                ])
            {
            Decimal rate = 0;
            if(currentAccount.Cases.size() > 0){
                for(Case currentCase : currentAccount.Cases){
                    rate += currentCase.Satisfaction_Rating__c;
                }
                currentAccount.Rating__c = rate / currentAccount.Cases.size();
            }
            else currentAccount.Rating__c = 0;               

            accountsToUpdate.add(currentAccount); 
        }
        
        update new List<Account>(accountsToUpdate);
        
    }

    private static Account recalculateAccountRating(Account currentAccount){            

        if(currentAccount.Cases != null && currentAccount.Cases.size() > 0){
            Decimal rate = 0;
            for(Case currentCase : currentAccount.Cases){
                rate += currentCase.Satisfaction_Rating__c;
            }
            currentAccount.Rating__c = rate / currentAccount.Cases.size();
        }

        return currentAccount;
    }
}