@isTest
private class SuppliersControllerTest {
    @TestSetup
    static void makeData(){
        insert new List<Account>{
            new Account(Name = 'TestAccount_USA', BillingCity = 'USA', BillingCountry = 'USA'),
            new Account(Name = 'TestAccount_MEXICO', BillingCity = 'Mexico', BillingCountry = 'Mexico')
        };
    }

    @isTest
    private static void testGetAccountById(){
        Account account = [SELECT Id FROM Account WHERE Name = 'TestAccount_USA'];

        Test.startTest();
            Account usaAccount = SuppliersController.getAccountById(account.Id);
        Test.stopTest();

        Assert.isNotNull(usaAccount);
    }

    @isTest
    private static void testGetAccountByIdNull(){
        Test.startTest();
            Account usaAccount = SuppliersController.getAccountById(null);
        Test.stopTest();

        Assert.isNull(usaAccount);
    }

    @isTest
    private static void testGetSuppliers(){
        List<Supplier__c> suppliers = TestDataFactory.createSuppliers(300, true);
        List<Account> accounts = [SELECT Id, BillingCity FROM Account ORDER BY Name];

        Test.startTest();
            List<Supplier__c> mexicoSuppliers = SuppliersController.getSuppliers(accounts[0].BillingCity);
            List<Supplier__c> usaSuppliers = SuppliersController.getSuppliers(accounts[1].BillingCity);
        Test.stopTest();

        Assert.areEqual(0, mexicoSuppliers.size());
        Assert.areEqual(300, usaSuppliers.size());
    }

    @isTest
    private static void testGetSuppliersNull(){
        Test.startTest();
            List<Supplier__c> nullSuppliers = SuppliersController.getSuppliers(null);
        Test.stopTest();

        Assert.areEqual(0, nullSuppliers.size());
    }

    @isTest
    private static void testgetSupplierById(){
        Supplier__c supplier = TestDataFactory.createSuppliers(1, true)[0];

        Test.startTest();
            Supplier__c actualSupplier = SuppliersController.getSupplierById(supplier.Id);
        Test.stopTest();

        Assert.isNotNull(actualSupplier);
    }

    @isTest
    private static void testgetSupplierByIdNull(){
        Test.startTest();
            Supplier__c actualSupplier = SuppliersController.getSupplierById(null);
        Test.stopTest();

        Assert.isNull(actualSupplier);
    }

}