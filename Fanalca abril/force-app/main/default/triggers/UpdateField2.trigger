/**
* Fanalca
* @author 			?
* Description:		Task trigger to manage all events.
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		06/02/2018		?						Trigger creation.
* @version	2.0		03/12/2018		Raul Mora (RM)			Trigger refactor.
*********************************************************************************************************/
trigger UpdateField2 on Task (before insert) 
{
    //03/12/2018 RM. Trigger refactor. 
    if( Trigger.isBefore && Trigger.isInsert ) {
        RM_TaskTriggerHandler_cls.taskBeforeInsert( Trigger.new );
    }
}