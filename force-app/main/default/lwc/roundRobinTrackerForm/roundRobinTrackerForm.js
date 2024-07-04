import { LightningElement, track, wire } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import USER_OBJECT from '@salesforce/schema/User';
import ROUND_ROBIN_TRACKER_OBJECT from '@salesforce/schema/Round_Robin_Tracker__c';
import ORDER_FIELD from '@salesforce/schema/Round_Robin_Tracker__c.Order__c';
import CURRENT_ASSIGNEE_FIELD from '@salesforce/schema/Round_Robin_Tracker__c.Current_Assignee__c';
import { getRecord } from 'lightning/uiRecordApi';

export default class RoundRobinTrackerForm extends LightningElement {
    @track order;
    @track currentAssignee;
    @track userOptions = [];

    @wire(getObjectInfo, { objectApiName: USER_OBJECT })
    userInfo;

    @wire(getPicklistValues, { recordTypeId: '$userInfo.data.defaultRecordTypeId', fieldApiName: 'Name' })
    wiredUsers({ error, data }) {
        if (data) {
            this.userOptions = data.values.map(user => {
                return { label: user.label, value: user.value };
            });
        } else if (error) {
            console.error('Error fetching users: ', error);
        }
    }

    handleInputChange(event) {
        const field = event.target.dataset.id;
        if (field === 'order') {
            this.order = event.target.value;
        } else if (field === 'currentAssignee') {
            this.currentAssignee = event.target.value;
        }
    }

    handleSave() {
        const fields = {};
        fields[ORDER_FIELD.fieldApiName] = this.order;
        fields[CURRENT_ASSIGNEE_FIELD.fieldApiName] = this.currentAssignee;

        const recordInput = { apiName: ROUND_ROBIN_TRACKER_OBJECT.objectApiName, fields };
        createRecord(recordInput)
            .then(record => {
                console.log('Record created with Id: ' + record.id);
            })
            .catch(error => {
                console.error('Error creating record: ' + error.body.message);
            });
    }
}
