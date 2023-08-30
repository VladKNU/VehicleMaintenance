import { LightningElement, api } from 'lwc';

import getSuppliers from '@salesforce/apex/SuppliersController.getSuppliers';
import { NavigationMixin } from 'lightning/navigation';
import {sortByDistance} from './suppliersTableHelper';

export default class SuppliersTable extends NavigationMixin(LightningElement) {

    activeAccount = {};

    pageSizeOptions = [5, 10, 25, 50, 75, 100];
    records = [];
    totalRecords = 0;
    pageSize;
    totalPages;
    pageNumber = 1;    
    recordsToDisplay = [];
    isSorted = false;
    isBlankData = true;    

    @api
    get account(){
        return this.activeAccount;
    }

    set account(value){
        this.activeAccount = value;
        this.getSuppliersList();
    }

    get bDisableFirst() {
        return this.pageNumber == 1;
    }

    get bDisableLast() {
        return this.pageNumber == this.totalPages;
    }

    async getSuppliersList(){
        try{
            this.records = await getSuppliers({billingCity: this.activeAccount.BillingCity});
            if(this.records.length > 0)
                this.isBlankData = false;
            this.sendComponentEvent("getallsuppliers", "success", this.records);
            this.totalRecords = this.records.length;
            this.pageSize = this.pageSizeOptions[0];
            this.paginationHelper();            
        } catch(ex){
            console.log(JSON(ex));
        }
    } 

    paginationHelper() {
        this.recordsToDisplay = [];
        this.totalPages = Math.ceil(this.totalRecords / this.pageSize);

        if (this.pageNumber <= 1) this.pageNumber = 1;
        else if (this.pageNumber >= this.totalPages) this.pageNumber = this.totalPages;        

        for (let i = (this.pageNumber - 1) * this.pageSize; i < this.pageNumber * this.pageSize; i++) {
            if (i === this.totalRecords) break;
            this.recordsToDisplay.push(this.records[i]);
        }
        
        this.sendComponentEvent("getsuppliers", "success", this.recordsToDisplay);
        isSorted = false;
    }

    recordNameClick(event) {   
        this[NavigationMixin.Navigate]({
            type: "standard__recordPage",
            attributes: {
              recordId: event.target.value,
              objectApiName: "Supplier__c",
              actionName: "view",
            },
          });
    }    

    createCaseClick(event){       
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Case',
                actionName: 'new'
            },
            state : {
                nooverride: '1',
                defaultFieldValues:`Origin=Phone,AccountId=${this.account.Id},Type=Other,Reason=Installation,Subject=Supplier: ${event.target.value}`
            }
        });
    }

    handleRecordsPerPage(event) {
        this.pageSize = event.target.value;
        this.paginationHelper();
    }

    previousPage() {
        this.pageNumber = this.pageNumber - 1;
        this.paginationHelper();
    }

    nextPage() {
        this.pageNumber = this.pageNumber + 1;
        this.paginationHelper();
    }

    handleSortClick(){
        if(!this.isSorted){
            let recs = this.recordsToDisplay;
            this.recordsToDisplay = [];
            this.recordsToDisplay = sortByDistance(recs, this.activeAccount);
            isSorted = true;
        }        
    }

    sendComponentEvent(eventName, status, message){
        this.dispatchEvent(new CustomEvent(eventName, {detail: {msg: message, status: status}}));
    }        
}