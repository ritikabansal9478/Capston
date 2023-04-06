import { LightningElement, api } from 'lwc';
import getProject from '@salesforce/apex/ProjectController.getProject';

export default class ExampleContainer extends LightningElement {
    @api recordId;
    
}