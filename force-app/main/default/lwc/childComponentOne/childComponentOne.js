import { LightningElement,api } from 'lwc';
export default class ChildComponentOne extends LightningElement {
    @api userName = '';
    connectedCallback() {
    console.log('username:', this.userName);
    }

    @api
    resetForm(){
        console.log('reset form called');
        this.template.quertSelector('[data-id="name"]').value = ' ';
        this.template.quertSelector('[data-id="email"]').value = ' ';
        this.template.quertSelector('[data-id="phone"]').value = ' ';
    }

    user = {
        Name : 'Uday',
        Age : 20 
    };

    handleChange(){
        user.Age = this.template.querySelector('[data-id="age"]').value;
    }


}