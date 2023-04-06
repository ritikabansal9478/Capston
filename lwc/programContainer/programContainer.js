import { LightningElement, api, track, wire } from 'lwc';
import getRelatedTask from '@salesforce/apex/TaskSelectorController.getRelatedTask'
import assignSelectedTaskToProgram from '@salesforce/apex/TaskSelectorController.assignSelectedTaskToProgram'
import searchTask from '@salesforce/apex/TaskSelectorController.searchTask'
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import fetchAssignedPrograms from '@salesforce/apex/TaskSelectorController.fetchAssignedPrograms';
import deleteSelectedTasks from '@salesforce/apex/TaskSelectorController.deleteSelectedTasks';
import addNewTaskToProgram from '@salesforce/apex/TaskSelectorController.addNewTaskToProgram';

const columns = [
    { label: 'Programs', fieldName: 'Name' },
    { label: 'Start Date', fieldName: 'Start_date_of_Program__c'},
];

export default class SuggestedTask extends LightningElement {
    @track showModal = false;
    @api recordId;
    @track searchData;
    @track taskRecords;
    @track columns = columns;
    @track errorMsg = '';


    inputText;
    submitText = '';

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
    
 @wire(getRelatedTask, { inputString: '$submitText', programId: '$recordId'})
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
    handleInputChange(event) {
        this.inputText = event.detail.value;
    }

    handleSearchClick() {
        this.submitText = this.inputText;
    }
    handleSearchButton(event) {
        if (event.keyCode === 13) {
            this.submitText = this.inputText;
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
    /*typeInformation(event) {
        this.searchValue = event.detail.value;
        console.log(this.searchValue);
    }*/

   /* createTheTaskInProgram() {
        addNewTaskToProgram({taskId: this.event.detail.Id, givenProgram: this.recordId})
        .then(response => {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success!',
                message: 'New Task Created Successfully!',
                variant: 'success',
                
            }));
            return this.relatedTasksResult;
            console.log("I am inside create the task in program");
        })
        .catch(error => {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success!',
                message: 'New Task Created Successfully!',
                variant: 'error',
                
            }));
        });    
    }*/

    handleSuccess(event) {
        let allModals = this.template.querySelectorAll('c-modal')[0];
        allModals.toggleModal();
        
        console.log("I am outside create the handle success then method");

        let newCreatedTask = event.detail.id;

        console.log(newCreatedTask);
        console.log(JSON.parse(JSON.stringify(newCreatedTask)));
       // console.log(newCreatedTask);
        addNewTaskToProgram({taskId: newCreatedTask, givenProgram: this.recordId})
        .then(response => {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success!',
                message: 'Task Created!',
                variant: 'success',
                
            }));
            return this.relatedTasksResult;
            console.log("I am inside create the handle success then method");
        })
        .catch(error => {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success!',
                message: 'ask Created!',
                variant: 'error',
                
            }));
        });  

        
    }

    
    handleAddeddTaskSuccess(event) {
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

    searchKeyword(event) {
        this.searchValue = event.detail.value;
        console.log(this.searchValue);
    }

    handleSearchKeyword() {
        {
            if(!this.searchValue) {
                this.errorMsg = 'Please enter Task name to search.';
                console.log('i am inside searcg')
                this.searchData = undefined;
                return;
            }
    
            searchTask({searchKey : this.searchValue})
            .then(result => {
                this.searchData = result;
                console.log(this.searchData);
            })
            .catch(error => {
                this.searchData = undefined;
                window.console.log('error =====> '+JSON.stringify(error));
                if(error) {
                    this.errorMsg = error.body.message;
                }
            }) 
        }
    }

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