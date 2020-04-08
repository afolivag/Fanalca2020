/**
* Fanalca
* @author 			Raul Mora
* Description:		Task trigger handler class.
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		03/12/2018		Raul Mora (RM)			Class definition.
*********************************************************************************************************/
public class RM_TaskTriggerHandler_cls {
    /**
	* @Method: 		taskBeforeInsert
	* @param: 		List Task
	* @Description: Refactor Task Trigger.
	* @author 		Raul Mora - 03122018
	*/
    public static void taskBeforeInsert( List<Task> lstTask ){
        updateTask( lstTask );
        checkCreatedTasks( lstTask );
    }
    
    /**
	* @Method: 		updateTask
	* @param: 		List Task
	* @Description: Refactor Task Trigger.
	* @author 		Raul Mora - 03122018
	*/
    public static void updateTask( List<Task> lstTask ) {
        if( lstTask.get(0).WhatId != null ) {
            //03/12/2018 RM. Obtain first record of the list to verify which object it is related to.
            ID idSObject = lstTask.get(0).WhatId;
            Schema.SObjectType sobjectType = idSObject.getSObjectType();
            String sobjectName = sobjectType.getDescribe().getName();
            //Verify if the related tasks are related to an AM_Oportunidad__c.
            if( sobjectName == System.Label.RM_OppNameLabelLBL ) {
                // creates a set of WhatIds of all the tasks in the trigger.
                Set<Id> taskIds = new Set<Id>();
                for(Task taskId: lstTask)
                   taskIds.add(taskId.WhatId); //WhatId is the opportunity (cotizacion in fanalca) id stored inside the task.
               
                //Do SOQL Query to get a map of opportunities (cotizaciones in fanalca) by the Id inside the taskIds.
                Map<Id, AM_Oportunidad__c> opps = new Map<Id, AM_Oportunidad__c>(
                    [SELECT AM_Usuario_motocicleta__r.PersonContact.Id, AM_Usuario_motocicleta__r.PersonEmail, AM_Usuario_motocicleta__r.Phone, 
                     AM_Usuario_motocicleta__r.PersonOtherPhone 
                     FROM AM_Oportunidad__c where Id IN :taskIds]);
              
                //for each task sets the WhoId (Nombre inside the task) by using the map named opps.
                for(Task taskId: lstTask){
                    //System.debug(opps.get(taskId.WhatId).AM_Usuario_motocicleta__r.PersonContact.Id);
                    //WhoId is the account person contact id of the account that will be stored in the task.
                    taskId.WhoId = opps.get(taskId.WhatId).AM_Usuario_motocicleta__r.PersonContact.Id;
                    //03/12/2018 RM. Populate field to disable "Actualizar Información cotización" process builder.
                    taskId.AM_Traer_informacion_Cotizaci_n__c = taskId.WhatId;
                    //12/02/2019 RM. Populate 3 fields.
                    taskId.AM_Correo_electronicoL__c = opps.get(taskId.WhatId).AM_Usuario_motocicleta__r.PersonEmail;
                    taskId.AM_Otro_TelefonoL__c = opps.get(taskId.WhatId).AM_Usuario_motocicleta__r.PersonOtherPhone;
                    taskId.AM_Telefono_Light__c = opps.get(taskId.WhatId).AM_Usuario_motocicleta__r.Phone;
                } 
            }
            //Verify if the related tasks are related to an Account.
            if( sobjectName == System.Label.RM_AccountLBL ) {
                // creates a set of WhatIds of all the tasks in the trigger.
                Set<Id> taskIds = new Set<Id>();
                for(Task taskId: lstTask) {
                    taskIds.add(taskId.WhatId);
                }
                
                //Do SOQL Query to get a map of accounts (cotizaciones in fanalca) by the Id inside the taskIds.
                Map<Id, Account> objAcc = new Map<Id, Account>(
                    [ SELECT Id, PersonEmail, Phone, PersonOtherPhone 
                      FROM Account where Id IN :taskIds ] );
                //for each task sets the WhoId (Nombre inside the task) by using the map named opps.
                for(Task taskId: lstTask){
                    taskId.AM_Correo_electronicoL__c = objAcc.get(taskId.WhatId).PersonEmail;
                    taskId.AM_Otro_TelefonoL__c = objAcc.get(taskId.WhatId).PersonOtherPhone;
                    taskId.AM_Telefono_Light__c = objAcc.get(taskId.WhatId).Phone;
                }
            }
        }        	
    }
    
    /**
	* @Method: 		checkCreatedTasks
	* @param: 		List Task
	* @Description: Method to verify if there is another open task related to the user.
	* @author 		Raul Mora - 02/25/2019
	*/
    public static void checkCreatedTasks( List<Task> lstTask ) {
        map<String,List<Task>> mpTask = new map<String,List<Task>>();
        map<String,List<Task>> mpTaskOwnOld = new map<String,List<Task>>();
        List<Task> lstTaskTemp;
        String strKeyTemp;
        for( Task objTask : lstTask ) {
            if( objTask.Subject != 'Cumpleaños de cliente' ) {
                lstTaskTemp = mpTask.containsKey( objTask.OwnerId ) ? mpTask.get( objTask.OwnerId ) : new List<Task>();
                lstTaskTemp.add( objTask );
                mpTask.put( objTask.OwnerId, lstTaskTemp );
            }
        }
        
        List<Task> lstCreatedTasks = [ Select Id, OwnerId, WhatId, WhoId, Subject
                                       From Task
                                       Where OwnerId IN: mpTask.keySet() 
                                       AND Status = 'Programada' ];
        
        if( !lstCreatedTasks.isEmpty() ) {
            for( Task objTa : lstCreatedTasks ) {
                for( Task objTaskTgr : mpTask.get( objTa.OwnerId ) ) {
                    if( objTaskTgr.WhatId != null ) {
                        if( objTaskTgr.WhatId == objTa.WhatId ) {
                            objTaskTgr.addError( 'Tiene una tarea programada, por favor revisela: <a href=\'/' + objTa.id + '\'>Tarea ' + objTa.Subject + '</a>', false);
                        }
                    } else {
                        if( objTaskTgr.WhoId == objTa.WhoId ) {
                            objTaskTgr.addError( 'Tiene una tarea programada, por favor revisela: <a href=\'/' + objTa.id + '\'>Tarea ' + objTa.Subject + '</a>', false);
                        }
                    }                    
                }            	
        	}
        }
    }

}