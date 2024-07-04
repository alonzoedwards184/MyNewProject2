import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { createRecord } from 'lightning/uiRecordApi';
import ROUND_ROBIN_TRACKER_OBJECT from '@salesforce/schema/Round_Robin_Tracker__c';
import CURRENT_ASSIGNEE_FIELD from '@salesforce/schema/Round_Robin_Tracker__c.Current_Assignee__c';
import ORDER_FIELD from '@salesforce/schema/Round_Robin_Tracker__c.Order__c';

export default class RoundRobinTrackerForm extends LightningElement {
    @track currentAssignee = '';
    @track order = '';

    handleInputChange(event) {
        const field = event.target.dataset.id;
        if (field === 'currentAssignee') {
            this.currentAssignee = event.target.value;
        } else if (field === 'order') {
            this.order = event.target.value;
        }
    }

    handleSave() {
        const fields = {};
        fields[CURRENT_ASSIGNEE_FIELD.fieldApiName] = this.currentAssignee;
        fields[ORDER_FIELD.fieldApiName] = this.order;

        const recordInput = { apiName: ROUND_ROBIN_TRACKER_OBJECT.objectApiName, fields };

        createRecord(recordInput)
            .then(record => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Round Robin Tracker record created',
                        variant: 'success',
                    }),
                );
                this.currentAssignee = '';
                this.order = '';
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating record',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
            });
    }
}
