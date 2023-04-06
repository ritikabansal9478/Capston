import { LightningElement, api, wire } from 'lwc';

export default class TestComponent extends LightningElement {

    @api recordId;

    testProperty = 'Ritika';

    connectedCallback() {
        this.testFunction('test input');
    }
    
    testFunction(input) {
        console.log(input);
    }
}