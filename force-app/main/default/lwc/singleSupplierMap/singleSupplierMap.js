import { LightningElement, api } from 'lwc';

import getSupplierById from '@salesforce/apex/SuppliersController.getSupplierById';

export default class SingleSupplierMap extends LightningElement {

    @api recordId;
    mapMarkers = [];

    connectedCallback(){
        this.getSupplierFromApex();                          
    } 

    async getSupplierFromApex(){
        try{
            let supplier = await getSupplierById({supplier_id: this.recordId});     
                      
            this.mapMarkers = [{
                location: {
                        Latitude: supplier.Location__Latitude__s,
                        Longitude: supplier.Location__Longitude__s,
                    },
                icon: 'custom:custom26',
                title: supplier.Name,
            }];        
        } catch(ex){
            console.log(JSON(ex));
        }
    }
}