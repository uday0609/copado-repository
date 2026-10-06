import {api} from 'lwc';
import LightningModal from 'lightning/modal';

export default class DetailModal extends LightningModal {
    @api accountData;

    handleClose(){
        this.close();
    }
}