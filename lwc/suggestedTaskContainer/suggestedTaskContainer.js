import { LightningElement, api, track, wire } from 'lwc';
import getRelatedTask from '@salesforce/apex/TaskSelectorController.getRelatedTask'
import assignSelectedTaskToProgram from '@salesforce/apex/TaskSelectorController.assignSelectedTaskToProgram'
import searchTask from '@salesforce/apex/TaskSelectorController.searchTask'
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import fetchAssignedPrograms from '@salesforce/apex/TaskSelectorController.fetchAssignedPrograms';
import deleteSelectedTasks from '@salesforce/apex/TaskSelectorController.deleteSelectedTasks';
import addNewTaskToProgram from '@salesforce/apex/TaskSelectorController.addNewTaskToProgram';
import { CloseActionScreenEvent } from 'lightning/actions';

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


    inputText;
    submitText = '';


    // Api considered as a reactive public property.  
   @api totalrecords;  
   @api currentpage;  
   @api pagesize;  
   // Following are the private properties to a class.  
   lastpage = false;  
   firstpage = false;  
   // getter  
   get showFirstButton() {  
     if (this.currentpage === 1) {  
       return true;  
     }  
     return false;  
   }
   // getter  
   get showLastButton() {  
    if (Math.ceil(this.totalrecords / this.pagesize) === this.currentpage) {  
      return true;  
    }  
    return false;  
  }  
  //Fire events based on the button actions  
  handlePrevious() {  
    this.dispatchEvent(new CustomEvent('previous'));  
  }  
  handleNext() {  
    this.dispatchEvent(new CustomEvent('next'));  
  }  
  handleFirst() {  
    this.dispatchEvent(new CustomEvent('first'));  
  }  
  handleLast() {  
    this.dispatchEvent(new CustomEvent('last'));  
  }  


    taskColumns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'Number of days to complete the Task', fieldName: "Number_of_days_to_complete_the_Task__c"},
        { label: 'Audience Type', fieldName: 'Audience_Type__c' },
    ]
    
    //originbal method
 /*@wire(getRelatedTask, {inputString: '$submitText', programId: '$recordId'})
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
    }*/


    //nrew method
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
    

    handleSuccess(event) {
        //let allModals = this.template.querySelectorAll('c-modal')[0];
        //allModals.toggleModal();
        this.dispatchEvent(new CloseActionScreenEvent());
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

    closeQuickAction(event){
        this.dispatchEvent(new CloseActionScreenEvent());
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
                //getRelatedTask(programId: '$recordId')
                //this.relatedTasksResult = result;
                return ;
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
}