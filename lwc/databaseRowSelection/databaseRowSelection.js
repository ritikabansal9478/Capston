import { LightningElement, track, wire, api } from 'lwc';

const columns = [
    {label: 'Name', fieldName: 'Name'},
    //{label : ''}
]
export default class DatabaseRowSelection extends LightningElement {
    @track showTasks = 'Show Tasks';
    @track isVisible = false;
    columns = columns;

    handleClick(event) {
        const label = event.target.label;

        if(label === 'Show Tasks') {
            this.showTasks = 'Hide Tasks';
            this.inVisible = true;
        }
        else if(label === 'Hide Tasks') {
            this.showTasks = 'Show Tasks';
            this.inVisible = false;
        }
    }
}