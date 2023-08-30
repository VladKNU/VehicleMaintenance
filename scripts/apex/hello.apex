

List<Supplier__c> ss = new List<Supplier__c>();
for (Integer i = 0; i < 105; i++){
    ss.add(new Supplier__c(Name = 'Name_'+i, City__c = 'Zhytomyr', Location__Latitude__s = (-90 + Math.random() * 180), Location__Longitude__s = (-180 + Math.random() * 360)));
}
insert ss;


//delete [SELECT id FROM Supplier__c];