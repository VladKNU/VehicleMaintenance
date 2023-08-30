public with sharing class SuppliersController {

    @AuraEnabled(cacheable=true) // use cacheble=true only when reading data, NOT with a DML!
    public static Account getAccountById(string account_id){

        if(account_id != null){
            Account account = [
                SELECT Id, Name, BillingCity, BillingLatitude, BillingLongitude, BillingPostalCode, BillingStreet, BillingState, BillingCountry  
                FROM Account 
                WHERE Id =: account_id];
            return account;
        }

        return null;
    }

    @AuraEnabled(cacheable=true) // use cacheble=true only when reading data, NOT with a DML!
    public static List<Supplier__c> getSuppliers(string billingCity){

        if(billingCity != null){
            List<Supplier__c> suppliers_list = [
                SELECT ID, City__c, Name, Location__Latitude__s, Location__Longitude__s 
                FROM Supplier__c 
                WHERE City__c =: billingCity
            ];

            if(suppliers_list.size() > 0){
                return suppliers_list;
            }
        }

        return new List<Supplier__c>();
    }

    @AuraEnabled(cacheable=true) 
    public static Supplier__c getSupplierById(string supplier_id){

        if(supplier_id != null){
            Supplier__c activeSupplier;

            activeSupplier = [
                SELECT Id, Name, City__c, Location__Latitude__s, Location__Longitude__s 
                FROM Supplier__c 
                WHERE Id =: supplier_id][0];
           
            return activeSupplier;
            
        }

        return null;

    }    
}