import { LightningElement, api, track, wire } from 'lwc';
import getRelatedTask from '@salesforce/apex/TaskSelectorController.getRelatedTask'
import assignSelectedTaskToProgram from '@salesforce/apex/TaskSelectorController.assignSelectedTaskToProgram'
import searchTask from '@salesforce/apex/TaskSelectorController.searchTask'
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import fetchAssignedPrograms from '@salesforce/apex/TaskSelectorController.fetchAssignedPrograms';
import deleteSelectedTasks from '@salesforce/apex/TaskSelectorController.deleteSelectedTasks';
import addNewTaskToProgram from '@salesforce/apex/TaskSelectorController.addNewTaskToProgram';
import { getRecord } from 'lightning/uiRecordApi';

//import CONTACT_FIRST_NAME from '@salesforce/schema/Contact.FirstName';

const columns = [
    { label: 'Programs', fieldName: 'Name' },
    { label: 'Contact', fieldName: 'Contact_Name__c'},
    { label: 'Start Date', fieldName: 'Start_date_of_Program__c'},
    
];


export default class SuggestedTask extends LightningElement {
    @track showModal = false;
    @api recordId;
    @track taskRecords;
    @track columns = columns;
    @track errorMsg = '';

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
    @wire(fetchAssignedPrograms, {givenProgram: '$recordId'})
    programs(results) {
        this.refreshTable = results;
        console.log(results);
        if (results.data) {
            this.data = results.data;
            this.error = undefined;

        } else if (results.error) {
            this.error = results.error;
            this.data = undefined;
        }
    }

    get name() {
        return this.contact.data.fields.Name.value;
    }

    getSelectedRecords(event) {        
        let selectedRows = event.detail.selectedRows;
        this.selectedRecords = selectedRows;      
    }

    deleteRecords() {
        if (this.selectedRecords) {
            this.buttonLabel = 'Processing....';
            this.isTrue = true;
            deleteSelectedTasks({assignedPrograms: this.selectedRecords }).then(result => {
                window.console.log('result ====> ' + result);
                this.buttonLabel = 'Delete Records';
                this.isTrue = false;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success!!',
                        message: this.recordsCount + ' records are deleted.',
                        variant: 'success'
                    }),
                );
                this.template.querySelector('lightning-datatable').selectedRows = [];
                this.recordsCount = 0;
                return refreshApex(this.refreshTable);
            }).catch(error => {
                this.buttonLabel = 'Delete Records';
                this.isTrue = false;                
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error while getting Contacts',
                        message: JSON.stringify(error),
                        variant: 'error'
                    }),
                );
            });
        }
    }

}