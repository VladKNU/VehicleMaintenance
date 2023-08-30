import { LightningElement, api } from "lwc";
import { updateRecord } from "lightning/uiRecordApi";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { notifyRecordUpdateAvailable } from 'lightning/uiRecordApi';

import ID_FIELD from "@salesforce/schema/Case.Id";
import STATUS_FIELD from "@salesforce/schema/Case.Status";

export default class CaseRateAction extends LightningElement {

    disabled = false;
    @api recordId;

    handleSubmit(e) {
        this.updateContact();
    }

    updateContact() {
   
        const fields = {};
        fields[ID_FIELD.fieldApiName] = this.recordId;
        fields[STATUS_FIELD.fieldApiName] = 'Closed';

        const recordInput = { fields };

        updateRecord(recordInput)
        .then(() => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: "Case successfully closed.",
                    message: "The evaluation form has been sent to the contact.",
                    variant: "success",
                }),
            );
            return refreshApex(this.recordId);
        })
        .catch((error) => {
            this.dispatchEvent(
            new ShowToastEvent({
                title: "Error closing case.",
                message: error.body.message,
                variant: "error",
            }),
            );
        });
        notifyRecordUpdateAvailable([{recordId: this.recordId}]);
      }

}