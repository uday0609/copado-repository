import { LightningElement } from 'lwc';
import createContacts from '@salesforce/apex/CreateContactController.CreateContacts';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class MyFirstComponent extends LightningElement {

    handleSave() {
        try {
            console.log('enter inside the submit');
            const nameInput = this.template.querySelector('[data-id="name"]');
            const phoneInput = this.template.querySelector('[data-id="phone"]');
            const emailInput = this.template.querySelector('[data-id="email"]');
            
            console.log('Inputs:', nameInput, phoneInput, emailInput);
            
            const nameVal = nameInput.value;
            const phone = phoneInput.value;
            const email = emailInput.value;

            console.log('Values:', nameVal, phone, email);

            const parts = nameVal.trim().split(' ');
            const firstName = parts[0];
            const lastName = parts.slice(1).join(' ') || 'NA';

            createContacts({ firstName, lastName, phone, email })
                .then(() => {this.dispatchEvent(new ShowToastEvent({title: 'Success',message: 'Contact Created Successfully',variant: 'success'}));})
                .catch(error => {
                    console.error('APEX ERROR:', error);
                    this.dispatchEvent( ShowToastEvent({title: 'Error',message: error?.body?.message || 'Something went wrong',variant: 'error'}));});
            
            this.template.querySelector('[data-id="name"]').value = '';
            this.template.querySelector('[data-id="phone"]').value = '';
            this.template.querySelector('[data-id="email"]').value = '';
        } 
        catch (error) {
            console.log('ERROR:', error.message);
        }
    }
}