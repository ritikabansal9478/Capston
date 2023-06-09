import { LightningElement, api } from 'lwc';

export default class Modal extends LightningElement {
    @api label;

    modalShown = false;

    @api
    toggleModal() {
        this.modalShown = !this.modalShown;
    }
}