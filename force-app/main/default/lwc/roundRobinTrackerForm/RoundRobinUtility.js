// RoundRobinUtility.js
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import ROUND_ROBIN_TRACKER_OBJECT from '@salesforce/schema/Round_Robin_Tracker__c';
import { getRecord } from 'lightning/uiRecordApi';

export default class RoundRobinUtility {
    constructor(userOptions) {
        this.userOptions = userOptions;
        this.roundRobinAssignments = [];
    }

    async getNextAssignee() {
        if (this.userOptions.length === 0) {
            throw new Error('No users available for round robin assignment.');
        }

        const order = await this.calculateOrderNumber();

        const index = this.roundRobinAssignments.length % this.userOptions.length;
        const assigneeId = this.userOptions[index].value;

        this.roundRobinAssignments.push(assigneeId);
        return { order, assigneeId };
    }

    async calculateOrderNumber() {
        const objectInfo = await getObjectInfo({ objectApiName: ROUND_ROBIN_TRACKER_OBJECT.objectApiName });
        const recordCount = objectInfo.recordCount;
        return recordCount + 1; // Increment to get the next order number
    }
}
