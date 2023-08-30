@isTest
private class CaseTriggerTest {
    
    @TestSetup
    static void makeData(){
        insert new Account(Name = 'Test Account', BillingCity = 'Kyiv', BillingCountry = 'Ukraine');
    }

    public static final string ERROR_MSG = 'It is not possible to update a closed case.';
    @isTest
    static void preventUpdatingClosedCaseTest(){

        List<Case> cases = TestDataFactory.createCasesOnAccount(101, 'Closed', [SELECT Id FROM Account][0]);
        for(Case updatedCase : cases){
            updatedCase.Origin = 'Web';
        }

        try{
            Test.startTest();
            update cases;
            Test.stopTest();
        }
        catch(Exception ex){
            Assert.isTrue(ex.getMessage().contains(ERROR_MSG));
        }

    }

    @isTest
    static void updateAccountRatingAfterUpdateTest(){

        List<Case> cases = TestDataFactory.createCasesOnAccount(105, 'Closed', [SELECT Id FROM Account][0]);
        for(Case updatedCase : cases){
            updatedCase.Satisfaction_Rating__c = (Integer)Math.floor(Math.random() * 5) + 1;
        }

        Test.startTest();
        update cases;
        Test.stopTest();

        Assert.isTrue([SELECT Id, Rating__c FROM Account][0].Rating__c > 0);

    }

    @isTest
    static void updateAccountRatingNoClosedCasesTest(){

        List<Case> cases = TestDataFactory.createCasesOnAccount(105, 'New', [SELECT Id FROM Account][0]);
        for(Case updatedCase : cases){
            updatedCase.Origin = 'Web';
        }

        Test.startTest();
        update cases;
        Test.stopTest();

        Assert.areEqual([SELECT Id, Rating__c FROM Account][0].Rating__c, 0);

    }

    @isTest
    static void updateAccountRatingAfterDeleteTest(){
        
        List<Case> cases = TestDataFactory.createCasesOnAccount(105, 'New', [SELECT Id FROM Account][0]);
        for(Case updatedCase : cases){
            updatedCase.Satisfaction_Rating__c = (Integer)Math.floor(Math.random() * 5) + 1;
            updatedCase.Status = 'Closed';
        }

        update cases;
                
        Test.startTest();       
        delete cases;
        Test.stopTest();

        Assert.isTrue([SELECT Id, Rating__c FROM Account][0].Rating__c == 0);
    }

    @isTest
    static void updateAccountRatingAfterDeleteNotNullTest(){
        
        List<Case> cases = TestDataFactory.createCasesOnAccount(105, 'New', [SELECT Id FROM Account][0]);
        
        for(Case updatedCase : cases){
            updatedCase.Satisfaction_Rating__c = (Integer)Math.floor(Math.random() * 5) + 1;
            updatedCase.Status = 'Closed';
        }

        update cases;
        cases.remove(0);
                
        Test.startTest();       
        delete cases;
        Test.stopTest();

        Assert.isTrue([SELECT Id, Rating__c FROM Account][0].Rating__c != 0);
    }
}