import { LightningElement } from 'lwc';
export default class ParentComponentSecond extends LightningElement {
    newLimit = 0;

    handleClick(){
        //console.log('enter the method parent ');
        this.newLimit = Number(this.template.querySelector('[data-id = "data-limit"]').value);
        Number(this.template.querySelector('[data-id= "data-limit"]').value = ' ');
    }
}