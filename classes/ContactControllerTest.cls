@isTest
private class ContactControllerTest {

    static testMethod void TestContactController(){
        Contact testContact = new Contact(LastName='test');
        insert testContact;
        ApexPages.currentPage().getParameters().put('id', testContact.Id);
      
        ContactController controller = new ContactController(); 
        System.assertEquals(testContact.Id, controller.currentuser.Id);
        System.assertEquals('Please go to the MATRIX tab and log into your portal.', controller.content);
        
        matrixlms__Matrix_Setting__c apiKey = new matrixlms__Matrix_Setting__c(Name='apiKey', matrixlms__Value__c='api_key_1234567890');
        insert apiKey;
        matrixlms__Matrix_Setting__c schoolId = new matrixlms__Matrix_Setting__c(Name='schoolId', matrixlms__Value__c='1234');
        insert schoolId;
        ContactController controller2 = new ContactController(); 
        System.assertEquals('This user doesn\'t have an associated email address.<br />Please enter an email address before adding this user to MATRIX.', controller2.content);
        
        Contact testContact2 = new Contact(Email='test@test.com', LastName='test');
        insert testContact2;
        ApexPages.currentPage().getParameters().put('id', testContact2.Id);
        
        ContactController controller4 = new ContactController(); 
        System.assertEquals('<a href="javascript:void(0)" id="addMatrixLink" onclick="addMatrixUser(\''+testContact2.Id+'\')">Add to MATRIX</a>', controller4.content);
        
        testContact2.matrixlms__Matrix_Userid__c = '178023';
        update testContact2;
        ContactController controller5 = new ContactController(); 
        System.assertEquals('<iframe id="matrixDetailsFrame" frameborder="0" width="100%" height="300" src="https://www.matrixlms.com/salesforce/user_details?userid=178023&api_key=api_key_1234567890&school_id=1234"></iframe>', controller5.content);
    }
    
}