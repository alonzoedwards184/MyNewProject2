// RoundRobinTrackerForm.js
import { LightningElement, track, wire } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import { loadStyle } from 'lightning/platformResourceLoader';
import ROUND_ROBIN_TRACKER_OBJECT from '@salesforce/schema/Round_Robin_Tracker__c';
import ORDER_FIELD from '@salesforce/schema/Round_Robin_Tracker__c.Order__c';
import CURRENT_ASSIGNEE_FIELD from '@salesforce/schema/Round_Robin_Tracker__c.Current_Assignee__c';
import getUsers from '@salesforce/apex/RoundRobinTrackerController.getUsers';
import checkDuplicateAssignee from '@salesforce/apex/RoundRobinTrackerController.checkDuplicateAssignee';
import roundRobinTrackerStyles from './roundRobinTrackerForm.css'; // Adjust relative path as needed

export default class RoundRobinTrackerForm extends LightningElement {
    @track order;
    @track currentAssignee;
    @track userOptions = [];
    @track nextOrder = 1; // Initialize next order number

    connectedCallback() {
        this.fetchUsers();
        this.loadStyles();
    }

    loadStyles() {
        loadStyle(this, roundRobinTrackerStyles)
            .catch(error => {
                console.error('Error loading styles: ', error);
            });
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
            // Check if the selected currentAssignee already exists
            checkDuplicateAssignee({ assigneeId: this.currentAssignee })
                .then(isDuplicate => {
                    if (isDuplicate) {
                        // Show error message or handle duplicate scenario
                        this.showToastMessage('Error', 'Duplicate assignee found. Please select another.', 'error');
                    } else {
                        const fields = {};
                        fields[ORDER_FIELD.fieldApiName] = this.nextOrder; // Set the order field with the next order number
                        fields[CURRENT_ASSIGNEE_FIELD.fieldApiName] = this.currentAssignee;

                        const recordInput = { apiName: ROUND_ROBIN_TRACKER_OBJECT.objectApiName, fields };
                        createRecord(recordInput)
                            .then(record => {
                                console.log('Record created with Id: ' + record.id);
                                // Optionally, reset form fields after successful save
                                this.order = null;
                                this.currentAssignee = null;
                                this.updateNextOrder(); // Update next order number after successful save
                            })
                            .catch(error => {
                                console.error('Error creating record: ', error.body.message);
                            });
                    }
                })
                .catch(error => {
                    console.error('Error checking duplicate assignee: ', error);
                });
        } catch (error) {
            console.error('Error in handleSave: ', error.message);
        }
    }

    updateNextOrder() {
        // Cycle through orders 1, 2, 3 and then repeat (circular order logic)
        this.nextOrder = this.nextOrder === 3 ? 1 : this.nextOrder + 1;
    }

    showToastMessage(title, message, variant) {
        const event = new CustomEvent('showtoast', {
            composed: true,
            bubbles: true,
            cancelable: true,
            detail: {
                title: title,
                message: message,
                variant: variant,
            },
        });
        this.dispatchEvent(event);
    }
}
