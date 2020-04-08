/**
* Fanalca
* @author           Alejandro Rebollo
* Description:      Test class for AR_opp_chk_tgr trigger.
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                  Description
*           -----   ----------      --------------------    ---------------
* @version  1.0     19/06/2019      Alejandro Rebollo (AR)  Class definition.
*********************************************************************************************************/

@isTest
public class AR_opp_chk_tst {
   public static AM_Oportunidad__c objOpp;
   public static AM_Oportunidad__c objOpp1;
    
    static testMethod void myUnitTest()
    {
        AO_diasActividadesCotizacion__c  objTest = new AO_diasActividadesCotizacion__c ();
        objTest.dias__C = 2;
        objTest.NAME = 'TEST';
        INSERT objTest;
        //Init test
        Test.StartTest();
        
        RecordType recTyp = [Select Id, Name From RecordType Where SobjectType = 'AM_Oportunidad__c' 
                             and Name = 'Cotizacion P.Natural Renting' Limit 1];
       
        Account objAcc = new Account();
        objAcc.Phone = '3103221212';
        objAcc.FirstName ='test';
        objAcc.LastName = 'Test';
        objAcc.Salutation = 'Sra.';
        objAcc.AM_Como_se_entero_de_la_marca__c = 'Radio';
        objAcc.AM_Genero__pc = 'Masculino';
        objAcc.PersonEmail = 'test@test.com';
        objAcc.AM_Numero_de_documento__c = '3040201';
        insert objAcc;
        
        AM_Producto__c objPrd = new AM_Producto__c();
        objPrd.AM_Activo__c = true;
        objPrd.AM_Ano__c = 2014;
        objPrd.AM_Codigo_de_producto__c = 'test';
        objPrd.AM_Color_disponible__c = 'AZUL SPORT';
        objPrd.AM_Precio_de_lista__c = 2000000;
        objPrd.Name = 'MotoTest';
        objPrd.Plan_Tipo_de_Producto_Unoe__c = 'MOTOCICLETA';
        objPrd.Plan_Tipo_de_Modelo_Unoe__c = 'GLAMOUR';
        insert objPrd; 
        
        AM_Plan_financiacion__c objPlanF = new AM_Plan_financiacion__c();
        objPlanF.Name = 'Test Plan Financiacion';
        objPlanF.AM_Activo__c = true;
        objPlanF.AM_Plan_financiacion__c = 'Flexible';
         insert objPlanF;
        
        objOpp = new AM_Oportunidad__c();
        objOpp.AM_Usuario_motocicleta__c = objAcc.Id;
        objOpp.AM_Propietario_motocicleta__c  = objAcc.Id;
        objOpp.RecordTypeId = recTyp.Id;
        objOpp.AM_Fecha_de_cierre__c = system.today().addDays( 2 );
        objOpp.AM_Modelo_de_interes__c = objPrd.Id;
        objOpp.AM_Color__c = 'AZUL SPORT';
        objOpp.AM_Valor_cuota_inicial__c = 100000;
        objOpp.AM_Valor_matricula__c = 20000;
        objOpp.AM_Valor_SOAT__c = 20000;
        objOpp.AM_Plazo__c = 12;
        objOpp.AM_Desea_incluir_seguro_de_robo__c = 'Si';
        objOpp.Uso_de_Motocicleta__c = 'Trabajo';
        objOpp.AM_Plan_de_financiacion__c = objPlanF.Id;
        objOpp.AM_Canal_de_atencion__c = 'E-mail';
        //objOpp.Forma_de_pago__c = 'Usados';
        objOpp.AM_Estado1__c = 'Activo';
        
        insert objOpp;

        Account objAcc1 = new Account();
        objAcc1.Phone = '3103221211';
        objAcc1.FirstName ='test2';
        objAcc1.LastName = 'Test2';
        objAcc1.Salutation = 'Sra.';
        objAcc1.AM_Como_se_entero_de_la_marca__c = 'Radio';
        objAcc1.AM_Genero__pc = 'Masculino';
        objAcc1.PersonEmail = 'test2@test2.com';
        objAcc1.AM_Numero_de_documento__c = '3040202';
        objAcc1.OwnerId = '0051N000007R4rVQAS'; 
        objAcc1.AM_Numero_de_documento__c ='138776354';
        insert objAcc1;
        
        objOpp1 = new AM_Oportunidad__c();
        objOpp1.AM_Usuario_motocicleta__c = objAcc1.Id;
        objOpp1.AM_Propietario_motocicleta__c  = objAcc1.Id;
        objOpp1.RecordTypeId = recTyp.Id;
        objOpp1.AM_Fecha_de_cierre__c = system.today();
        objOpp1.AM_Modelo_de_interes__c = objPrd.Id;
        objOpp1.AM_Color__c = 'AZUL SPORT';
        objOpp1.AM_Valor_cuota_inicial__c = 100000;
        objOpp1.AM_Valor_matricula__c = 20000;
        objOpp1.AM_Valor_SOAT__c = 20000;
        objOpp1.AM_Plazo__c = 12;
        objOpp1.AM_Desea_incluir_seguro_de_robo__c = 'Si';
        objOpp1.Uso_de_Motocicleta__c = 'Trabajo';
        objOpp1.AM_Plan_de_financiacion__c = objPlanF.Id;
        objOpp1.AM_Canal_de_atencion__c = 'E-mail';
        // objOpp1.Forma_de_pago__c = 'Usados';
        objOpp1.AM_Estado1__c = 'Activo';

        try {        
          insert objOpp1;
        } 
           catch(Exception z)
         {   
                System.Assert(z.getMessage().contains('No tiene acceso a la creación de cotizaciones para esta cuenta.'));
          }
        
        // End test
        Test.StopTest();
    }
}