import { LightningElement, track, wire } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import { loadStyle } from 'lightning/platformResourceLoader';
import ROUND_ROBIN_TRACKER_OBJECT from '@salesforce/schema/Round_Robin_Tracker__c';
import ORDER_FIELD from '@salesforce/schema/Round_Robin_Tracker__c.Order__c';
import CURRENT_ASSIGNEE_FIELD from '@salesforce/schema/Round_Robin_Tracker__c.Current_Assignee__c';
import getGroupMembers from '@salesforce/apex/RoundRobinTrackerController.getGroupMembers';
import roundRobinTrackerStyles from '@salesforce/resourceUrl/roundRobinTracker'; // Adjust the resource URL as needed

export default class RoundRobinTrackerForm extends LightningElement {
    @track order;
    @track currentAssignee;
    @track userOptions = [];

    groupId = '00Gxxxxxxxxxxxx'; // Replace with your Group ID

    connectedCallback() {
        this.fetchGroupMembers();
        this.loadStyles();
    }

    loadStyles() {
        Promise.all([
            loadStyle(this, roundRobinTrackerStyles)
        ]).catch(error => {
            console.log('Error loading styles: ' + JSON.stringify(error));
        });
    }

    fetchGroupMembers() {
        getGroupMembers({ groupId: this.groupId })
            .then(result => {
                this.userOptions = result.map(user => {
                    return { label: user.Name, value: user.Id };
                });
                if (this.userOptions.length > 0) {
                    this.currentAssignee = this.userOptions[0].value;
                }
            })
            .catch(error => {
                console.error('Error fetching group members: ', error);
            });
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
