import { LightningElement, api } from 'lwc';
import getRelatedTimecards from '@salesforce/apex/TimecardApprovalController.getRelatedTimecards';
import createNewTimecard from '@salesforce/apex/TimecardApprovalController.createNewTimecard';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ApproveOrRejectTimecardsContainer extends LightningElement {
    @api recordId;

    timecards;
    modalShown = false;

    connectedCallback() {
        getRelatedTimecards( { projectId: this.recordId } )
            .then(timecards => {
                console.log(timecards);
                this.timecards = timecards;
            })
            .catch(error => {
                console.warn(error);
            });
    }
    
    createTimecard() {
        createNewTimecard({
            projectId: this.recordId
        })
        .then(timecard => {
            console.log(timecard);
        })
        .catch(error => {
            console.warn(error);
        });
    }

    toggleModal() {
        this.modalShown = !this.modalShown;
    }

    handleSuccess(event) {
        this.dispatchEvent(new ShowToastEvent({
            title: 'Success!',
            message: 'Timecard ' + event.detail.id + ' created successfully!',
            variant: {label: 'success', value: 'success' },
        }));
    }
}