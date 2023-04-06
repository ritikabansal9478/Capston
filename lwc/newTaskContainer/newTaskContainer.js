import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';

const columns = [
    { label: 'Programs', fieldName: 'Name' },
    { label: 'Start Date', fieldName: 'Start_date_of_Program__c'},
];

export default class SuggestedTask extends LightningElement {
    @track showModal = false;
    @api recordId;
    @track taskRecords;
    @track columns = columns;
    @track errorMsg = '';

    data;
    taskShown= true;
    searchValue = '';
    modalShown = false;
    tasks;
    selectedRecords = [];
    selectedTasks = [];
    relatedTasksResult =[];
    refreshTable;
    error;

    taskColumns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'Number of days to complete the Task', fieldName: "Number_of_days_to_complete_the_Task__c"},
        { label: 'Audience Type', fieldName: 'Audience_Type__c' },
    ]

    handleSuccess(event) {
       // this.dispatchEvent(new CloseActionScreenEvent());
        this.dispatchEvent(new ShowToastEvent({
            title: 'Success!',
            message: 'New Task Created Successfully!',
            variant: 'success',
            
        }));
    }

    handleCloseWindow(event) {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    handleAddeddTaskSuccess(event) {
        let allModals = this.template.querySelectorAll('c-modal')[0];
        allModals.toggleModal();
        this.dispatchEvent(new ShowToastEvent({
            title: 'Success!',
            message: 'Added Successfully!',
            variant: 'success',
        }));
    }

    toggleModal() {
        this.modalShown = !this.modalShown;
    }

    toggleNewTask() {
        this.taskShown = !this.taskShown;
    }

}
