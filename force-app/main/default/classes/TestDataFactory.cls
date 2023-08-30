@isTest
public class TestDataFactory {
    public static List<Supplier__c> createSuppliers(Integer suppliersNumber, Boolean isInsert){
        if(suppliersNumber > 0){
            List<Supplier__c> supplierList = new List<Supplier__c>();
            for (integer i = 0; i < suppliersNumber; i++){
                supplierList.add(new Supplier__c(
                    Name = 'name_'+i, 
                    City__c = 'USA', 
                    Location__Latitude__s = (Math.random() * 90), 
                    Location__Longitude__s = (Math.random() * 180)));
            }         

            if(isInsert != false){
                 insert supplierList;   
            }

            return supplierList;
        }
        else {
            return new List<Supplier__c>();
        }
    }

    public static List<Account> createAccounts(Integer accountsNumber, String city, Boolean isInsert){
        if(accountsNumber > 0){
            city = city != null ? city : 'USA';
            List<Account> accountList = new List<Account>();
            for (Integer i = 0; i < accountsNumber; i++){
                accountList.add(new Account(
                    Name = 'Account_' + i, 
                    BillingCountry = city, 
                    BillingCity = city,
                    Rating__c = 0
                ));
            }

            if(isInsert){
                insert accountList; 
            }

            return accountList;
        }
        else {
            return new List<Account>();
        }
    }

    public static List<Case>createCases(Integer accountNumber, Integer casesPerAccount, String caseStatus, Boolean isInsert){
        if(casesPerAccount > 0){
            List<Case> cases = new List<Case>();

            for(Account acc : createAccounts(accountNumber, null, true)){
                for(Integer index = 0; index < casesPerAccount; index++){
                    cases.add(new Case(
                        Status = caseStatus,
                        Origin = 'Phone',
                        AccountId = acc.Id,
                        Satisfaction_Rating__c = 0
                    ));
                }
            }

            if (isInsert != false)
                insert cases;

            return cases;
        }
        else {
            return null;
        }
    }

    public static List<Case> createCasesOnAccount(Integer casesNumber, String status, Account account){
        if(casesNumber > 0){
            List<Case> casesToInsert = new List<Case>();
            for(Integer i = 0; i < casesNumber; i++){
                casesToInsert.add(new Case(
                    Status = status, 
                    Origin = 'Phone',
                    AccountId = account.Id));
            }

            insert casesToInsert;

            return casesToInsert;
        }
        else {
            return null;
        }
    }
}