import { LightningElement, api, track } from 'lwc';

import { notifyRecordUpdateAvailable } from 'lightning/uiRecordApi';
import getAccountById from '@salesforce/apex/SuppliersController.getAccountById';

export default class Suppliers extends LightningElement {

    @api recordId; 
    @track account;
    title; 
    suppliersList = [];       
    isBlankData = true;
    isSpinner = true;
    
    connectedCallback(){
        this.getAccount();
        notifyRecordUpdateAvailable([{recordId: this.recordId}]);
    }

    async getAccount(){
        try{
            this.account = await getAccountById({account_id: this.recordId});                        
        } catch(ex){
            console.log(JSON(ex));
        }       
    }

    handleGetSuppliers(event){
        this.suppliersList = event.detail.msg;
        if(event.detail.msg.length > 0)
            this.isBlankData = false;
        this.isSpinner = false;
    }

    handleGetAllSuppliers(event){
        this.title = `Suppliers (${event.detail.msg.length})`;
    }    
}