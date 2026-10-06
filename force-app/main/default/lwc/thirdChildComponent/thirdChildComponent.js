import { LightningElement,api } from 'lwc';
export default class ThirdChildComponent extends LightningElement {
    @api firstName = '';
    @api lastName = '';

    checkIncomplete(){
        return !this.firstName && !this.lastName;
    }
}