import { LightningElement } from 'lwc';

export default class ComponentTwo extends LightningElement {
   list = [];

   formData = {
        firstName : '',
        lastName : '',
        email : '',
        phone : '',
        title : '',
        department : ''
   }

   columns = [
      {label: 'First Name', fieldName: 'firstName', type: 'text' },
      { label: 'Last Name', fieldName: 'lastName', type: 'text' },
      {label : 'Email', fieldName : 'email' , type : 'email'},
      {label : 'Phone', fieldName : 'phone', type : 'tel'},
      {label : 'Title', fieldName : 'title', type : 'text'},
      {label : 'Department', fieldName : 'department', type : 'text'},
   ];

   handleChange(event){
     const{name,value} = event.target;
     this.formData = {...this.formData, [name] : value};
   }

   handleClick(){
     console.log(JSON.stringify(this.formData));
     this.list= [...this.list,this.formData];
   }
}