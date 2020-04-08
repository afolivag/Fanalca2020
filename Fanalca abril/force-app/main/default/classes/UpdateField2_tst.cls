/**
* Fanalca
* @author           ?
* Description:      Test class for Task trigger (UpdateField2).
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                  Description
*           -----   ----------      --------------------    ---------------
* @version  1.0     05/02/2018      ?                       Class definition.
* @version  1.0     03/12/2018      Raul Mora (RM)          Adjust to increase coverage.
*********************************************************************************************************/
@isTest
private class UpdateField2_tst {
    static testMethod void myUnitTest() {
        //03/12/2018 RM. Remove record type name as where condition.
        RecordType recTyp = [Select Id, Name From RecordType Where SobjectType = 'AM_Oportunidad__c' Limit 1];
        
        Account cuenta = new Account();
        //RM 14-01-2019. Adjust test class coverage.
        cuenta.Phone = '3103221212';
        cuenta.FirstName ='test';
        cuenta.LastName = 'Test';
        //03/12/2018 RM. Validation rule require salutation to create account.
        cuenta.Salutation = 'Sra.';
        cuenta.AM_Como_se_entero_de_la_marca__c = 'Radio';
        cuenta.AM_Genero__pc = 'Masculino';
        cuenta.PersonEmail = 'test@test.com';
        insert cuenta;
        
        AM_Producto__c prod = new AM_Producto__c();
        prod.AM_Activo__c = true;
        prod.AM_Ano__c = 2014;
        prod.AM_Codigo_de_producto__c = 'test';
        prod.AM_Color_disponible__c = 'Rojo';
        prod.AM_Precio_de_lista__c = 2000000;
        prod.Name = 'MotoTest';
        prod.Plan_Tipo_de_Producto_Unoe__c = 'MOTOCICLETA';
        prod.Plan_Tipo_de_Modelo_Unoe__c = 'GLAMOUR';
        insert prod; 
        
        //03/12/2018 RM. Create test data for plan de financiacion.
        AM_Plan_financiacion__c objPlanF = new AM_Plan_financiacion__c();
        objPlanF.Name = 'Test Plan Financiacion';
        objPlanF.AM_Activo__c = true;
        objPlanF.AM_Plan_financiacion__c = 'Flexible';
        insert objPlanF;
        
        AM_Oportunidad__c cot = new AM_Oportunidad__c();
        cot.AM_Usuario_motocicleta__c = cuenta.Id;
        //RM 14-01-2019. Adjust test class coverage.
        cot.AM_Propietario_motocicleta__c  = cuenta.Id;
        cot.RecordTypeId = recTyp.Id;
        Cot.AM_Fecha_de_cierre__c = system.today();
        cot.AM_Modelo_de_interes__c = prod.Id;
        cot.AM_Color__c = 'ROJO';
        cot.AM_Valor_cuota_inicial__c = 100000;
        cot.AM_Valor_matricula__c = 20000;
        cot.AM_Valor_SOAT__c = 20000;
        cot.AM_Plazo__c = 12;
        cot.AM_Desea_incluir_seguro_de_robo__c = 'Si';
        //03/12/2018 RM. Restricted picklist, it had a value that was not included.
        cot.AM_Canal_de_atencion__c = 'Volantes';
        cot.Uso_de_Motocicleta__c = 'Trabajo';
        //03/12/2018 RM. Assign a plan de financiacion.
        cot.AM_Plan_de_financiacion__c = objPlanF.Id;
        //03/12/2018 RM. Include required fields.
        cot.Forma_de_pago__c = 'Contado';
        cot.AM_Estado1__c = 'Activo';
        insert cot;
        
        //03/12/2018 RM. Create test data for task to excecute trigger.
        Task objTask = new Task();
        objTask.WhatId = cot.Id;
        objTask.Description = 'Test';
        //insert objTask;
        
        
   }
    
    static testMethod void myUnitTest2() {        
        Account cuenta = new Account();
        //RM 14-01-2019. Adjust test class coverage.
        cuenta.Phone = '3103221212';
        cuenta.FirstName ='test';
        cuenta.LastName = 'Test';
        //03/12/2018 RM. Validation rule require salutation to create account.
        cuenta.Salutation = 'Sra.';
        cuenta.AM_Como_se_entero_de_la_marca__c = 'Radio';
        cuenta.AM_Genero__pc = 'Masculino';
        cuenta.PersonEmail = 'test@test.com';
        insert cuenta;        
        
        
        //03/12/2018 RM. Create test data for task to excecute trigger.
        Task objTask = new Task();
        objTask.WhatId = cuenta.Id;
        objTask.Description = 'Test';
        insert objTask;
        
        
   }
   }