import { LightningElement,track} from 'lwc';

export default class ComponentOne extends LightningElement {
    
    list = [];

    @track formData = {
        title : '',
        progress : ''
    }

    options = [
        {label : 'Low', value : 'Low'},
        {label : 'Medium', value: 'Medium'},
        {label : 'High Priority', value: 'High Priority'}
    ]

    columns = [
        { label: 'Task Title', fieldName: 'title', type: 'text' },
        { label: 'Status', fieldName: 'progress', type: 'text' }
    ];

    value = '';
    
    handleChange(event){
        const {name,value} = event.target;
        this.formData = {...this.formData, [name]: value };
    }

    handleClick(){
        try{
            this.list = [...this.list, this.formData];
            this.formData = {title : '', progress: ''};
        }
        catch(Error){
            console.log(Error.message);
        }       
    }
}