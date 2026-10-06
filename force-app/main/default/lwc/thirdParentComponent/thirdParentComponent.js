import { LightningElement } from 'lwc';
export default class ThirdParentComponent extends LightningElement {
    first = '';
    last = '';
    handleChange(){
        try{
             this.first = this.template.querySelector('[data-id = "first-name"]').value;
             //console.log(this.first);
             this.last =  this.template.querySelector('[data-id = "last-name"]').value;
             //console.log(this.last);
        }
        catch(error){
            console.log(error.message);
        }  
    }
}