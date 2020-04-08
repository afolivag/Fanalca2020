/*********************************************************************************************************************
*   @Class          :   AO_FollowingTaskAlert_ctr
*   @Author         :   Andrés Oliva andresolivag@gmail.com
*   @Created        :   22/03/2020
*   @Description    :   Aura component for WTBD list
*
*      Author                   Date                     Description
*      Andrés Oliva             04/10/2019               Show an alert when the task number is gratter than the max allowed in the
                                                         custom metadata AO_FollowingTaskAllowed_mtd
**************************************************************************************************************************/
public without sharing class AO_FollowingTaskAlert_ctr {
    
    /***************************************************************************************************************************  
    * @Method          :   showAlert
    * @Author          :   Andrés Oliva <andres.oliva@cogniznat.com>
    * @Created         :   04/10/2019
    * @Description     :   Return true when the task following number is gratter than the allowed in custom metadata  AO_FollowingTaskAllowed_mtd
    * @param        :   
    ****************************************************************************************************************************/   
    @AuraEnabled
    public static wrpResponse showAlert(id idTask, id QuoteId, date datSelected ){
        AO_FollowingTask__mdt objMaxFollowing   =   [SELECT Id,AO_maxTaskNumber_fld__c FROM AO_FollowingTask__mdt WHERE DeveloperName ='X10'];
        task objTask = getTask( idTask );
        if( objTask.status.equals('Programada')){
            objTask.Fecha_de_proximo_seguimiento__c = datSelected;
        	update objTask;
        }
        
        integer intFollowingTask = [SELECT Count() FROM Task WHERE WhatId =: objTask.whatId OR accountId =:objTask.accountId];             
        Boolean hasShowAler = intFollowingTask >= objMaxFollowing.AO_maxTaskNumber_fld__c ? true: false;
        wrpResponse objResponse = new wrpResponse();
        objResponse.blnSwowAlert = hasShowAler ;
        objResponse.intTaskNumber = intFollowingTask ;
        system.debug('\n wrp response @@@ ' + JSON.serializePretty( objResponse ) );
        return objResponse;
    }
    
    /***************************************************************************************************************************  
    * @Method          :   getTask
    * @Author          :   Andrés Oliva <andres.oliva@cogniznat.com>
    * @Created         :   04/10/2019
    * @Description     :   Return a task record
    * @param        :   
    ****************************************************************************************************************************/   
    @AuraEnabled
    public static task getTask( id idTask ){
        return [ Select whatId,accountId,status,Fecha_de_proximo_seguimiento__c FROM TASK WHERE Id=: idTask ];        
    }
    /*wrapper class to shoAlert*/
    public class wrpResponse{
        @AuraEnabled public boolean    blnSwowAlert;
        @AuraEnabled public Integer    intTaskNumber;    
    }
}