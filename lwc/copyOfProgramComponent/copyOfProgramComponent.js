import { LightningElement, api, track, wire } from 'lwc';
import getRelatedTask from '@salesforce/apex/TaskSelectorController.getRelatedTask'
import assignSelectedTaskToProgram from '@salesforce/apex/TaskSelectorController.assignSelectedTaskToProgram'
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import { CloseActionScreenEvent } from 'lightning/actions';

const columns = [
    { label: 'Programs', fieldName: 'Name' },
    { label: 'Start Date', fieldName: 'Start_date_of_Program__c'},
];

export default class SuggestedTask extends LightningElement {
    //@track showModal = false;
    @api recordId;
    //@track taskRecords;
    @track columns = columns;
    //@track errorMsg = '';

    data;
    taskShown= false;
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
    
 @wire(getRelatedTask, {programId: '$recordId'})
    wiredRelatedTasks(result){
        this.relatedTasksResult = result;
        if(result.data){
            this.tasks = result.data;
            this.error = undefined;
        }
        else if(result.error){
            this.error = result.error;
            this.tasks = undefined;
        }
    }

    handleRowSelection(event) {
        const selectedRows = event.detail.selectedRows;
        this.selectedTasks = [];
        for(let i = 0; i<selectedRows.length; i++) {
            this.selectedTasks.push(selectedRows[i].Id);
        }
        console.log(this.selectedTasks);
    }


    get isButtonDisabled() {
        return this.selectedTasks.length === 0;
        //console.log("this is inside the disabled error");
    }

    handleAssignSelectedTaskToProgram() {
        assignSelectedTaskToProgram({taskIn: this.selectedTasks, programId: this.recordId})
        .then(response => {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success!',
                message: 'New Task Created Successfully!',
                variant: 'success',
                
            }));
            return refreshApex(this.relatedTasksResult);
        })
        .catch(error => {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success!',
                message: 'New Task Created Successfully!',
                variant: 'error',
                
            }));
        });    
    }

    handleSuccess(event) {
        this.dispatchEvent(new CloseActionScreenEvent());
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
