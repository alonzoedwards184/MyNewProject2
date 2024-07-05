import { LightningElement, track, wire } from 'lwc';
import { createRecord, updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getUsers from '@salesforce/apex/RoundRobinTrackerController.getUsers';
import getNextAssignee from '@salesforce/apex/RoundRobinTrackerController.getNextAssignee';
import ROUND_ROBIN_TRACKER_OBJECT from '@salesforce/schema/Round_Robin_Tracker__c';
import ORDER_FIELD from '@salesforce/schema/Round_Robin_Tracker__c.Order__c';
import CURRENT_ASSIGNEE_FIELD from '@salesforce/schema/Round_Robin_Tracker__c.Current_Assignee__c';
import OPPORTUNITY_OBJECT from '@salesforce/schema/Opportunity';
import OWNER_ID_FIELD from '@salesforce/schema/Opportunity.OwnerId';

export default class RoundRobinTrackerForm extends LightningElement {
    @track order;
    @track currentAssignee;
    @track userOptions = [];
    @track nextOrder = 1; // Initialize next order number

    connectedCallback() {
        this.fetchUsers();
    }

    fetchUsers() {
        getUsers()
            .then(result => {
                this.userOptions = result.map(user => {
                    return { label: user.Name, value: user.Id };
                });
                if (this.userOptions.length > 0) {
                    this.currentAssignee = this.userOptions[0].value; // Set default value if needed
                }
            })
            .catch(error => {
                console.error('Error fetching users: ', error);
                this.showToast('Error', 'Error fetching users: ' + error.body.message, 'error');
            });
    }

    handleInputChange(event) {
        const field = event.target.dataset.id;
        if (field === 'order') {
            this.order = event.target.value;
        } else if (field === 'currentAssignee') {
            this.currentAssignee = event.detail.value; // Update currentAssignee with selected value
        }
    }

    handleSave() {
        try {
            getNextAssignee()
                .then(assigneeId => {
                    const fields = {};
                    fields[ORDER_FIELD.fieldApiName] = this.nextOrder; // Set the order field with the calculated order number
                    fields[CURRENT_ASSIGNEE_FIELD.fieldApiName] = assigneeId;

                    const recordInput = { apiName: ROUND_ROBIN_TRACKER_OBJECT.objectApiName, fields };
                    createRecord(recordInput)
                        .then(record => {
                            console.log('Record created with Id: ' + record.id);
                            this.showToast('Success', 'Record created successfully', 'success');
                            this.updateOpportunityOwner(assigneeId); // Update Opportunity owner with the next assignee
                            this.updateNextOrder(); // Update next order number after successful save
                            this.order = null;
                            this.currentAssignee = null;
                        })
                        .catch(error => {
                            console.error('Error creating record: ', error.body.message);
                            this.showToast('Error', 'Error creating record: ' + error.body.message, 'error');
                        });
                })
                .catch(error => {
                    console.error('Error getting next assignee: ', error.message);
                    this.showToast('Error', 'Error getting next assignee: ' + error.message, 'error');
                });
        } catch (error) {
            console.error('Error in handleSave: ', error.message);
            this.showToast('Error', 'Error in handleSave: ' + error.message, 'error');
        }
    }

    updateOpportunityOwner(assigneeId) {
        // Replace 'yourOpportunityId' with the actual Opportunity Id
        const fields = {};
        fields[OWNER_ID_FIELD.fieldApiName] = assigneeId;
        fields.Id = 'yourOpportunityId'; // Set the Opportunity Id here

        const recordInput = { fields };
        updateRecord(recordInput)
            .then(() => {
                this.showToast('Success', 'Opportunity owner updated successfully', 'success');
            })
            .catch(error => {
                console.error('Error updating Opportunity owner: ', error.body.message);
                this.showToast('Error', 'Error updating Opportunity owner: ' + error.body.message, 'error');
            });
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(event);
    }

    updateNextOrder() {
        // Cycle through orders 1, 2, 3 and then repeat (circular order logic)
        this.nextOrder = this.nextOrder === 3 ? 1 : this.nextOrder + 1;
    }
}
