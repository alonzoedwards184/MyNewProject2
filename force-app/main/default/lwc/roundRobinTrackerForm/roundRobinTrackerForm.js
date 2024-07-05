// roundRobinTrackerForm.js

import { LightningElement, track } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import getUsers from '@salesforce/apex/RoundRobinTrackerController.getUsers';
import createRoundRobinTrackerRecord from '@salesforce/apex/RoundRobinTrackerController.createRoundRobinTrackerRecord';
import roundRobinTrackerStyles from './roundRobinTrackerForm.css'; // Adjust relative path as needed


export default class RoundRobinTrackerForm extends LightningElement {
    @track order;
    @track currentAssignee;
    @track userOptions = [];
    @track nextOrder = 1; // Initialize next order number
    @track errorMessage = '';

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
            createRoundRobinTrackerRecord({ nextOrder: this.nextOrder, currentAssignee: this.currentAssignee })
                .then(recordId => {
                    console.log('Record created with Id: ' + recordId);
                    this.order = null;
                    this.currentAssignee = null;
                    this.updateNextOrder(); // Update next order number after successful save
                    this.errorMessage = null; // Clear any previous errors
                })
                .catch(error => {
                    console.error('Error creating record: ', error);
                    this.errorMessage = error.body.message || 'Unknown error'; // Display the error message
                });
        } catch (error) {
            console.error('Error in handleSave: ', error.message);
            this.errorMessage = error.message || 'Unknown error'; // Fallback for any unexpected errors
        }
    }
    
    
    updateNextOrder() {
        // Cycle through orders 1, 2, 3 and then repeat (circular order logic)
        this.nextOrder = this.nextOrder === 3 ? 1 : this.nextOrder + 1;
    }
}
