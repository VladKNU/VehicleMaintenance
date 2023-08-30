import { LightningElement, api } from 'lwc';

import { notifyRecordUpdateAvailable } from 'lightning/uiRecordApi';

export default class SuppliersMap extends LightningElement {
    suppliers = [];
    mapMarkers = [];
    activeAccount = {}; 

    @api
    get account(){
        return this.activeAccount;
    }

    set account(value){        
        this.activeAccount = value;    
        this.setMapMarkers()                   
    }

    @api 
    get suppliersList(){
        return this.suppliers;
    }

    set suppliersList(value){
        this.suppliers = value;
        this.setMapMarkers();
    }     

    setMapMarkers(){
        this.mapMarkers = new Array();
        if(this.activeAccount != undefined){
            this.mapMarkers = [...this.mapMarkers,
                {   
                    location: {
                        Latitude: this.activeAccount.BillingLatitude,
                        Longitude: this.activeAccount.BillingLongitude,
                    },
                    //icon: 'standard:account',
                    title: this.activeAccount.Name,
                    mapIcon: {
                        path: 'M 0,0 C -2,-20 -10,-22 -10,-30 A 10,10 0 1,1 10,-30 C 10,-22 2,-20 0,0 z',
                        fillColor: '#57b336',
                        fillOpacity: 1,
                        strokeOpacity: 1,
                        strokeColor: '#000',
                        strokeWeight: 1,
                    }             
                },
            ];
            notifyRecordUpdateAvailable([{recordId: this.activeAccount.id}]);   
        }  
        this.suppliers.forEach(element => {
            this.mapMarkers = [...this.mapMarkers,
                {   
                    location: {
                        Latitude: element.Location__Latitude__s,
                        Longitude: element.Location__Longitude__s,
                    },
                    icon: 'custom:custom26',
                    title: element.Name,
                },
            ];
        });  
    }

}