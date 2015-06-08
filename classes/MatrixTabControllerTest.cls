@isTest
private class MatrixTabControllerTest {

    static testMethod void TestMatrixTabController(){
        User testUser = new User(Username='test_matrixlms_15052015@test.com', Email='test@test.com', Alias='test', LastName='test', CommunityNickname='test', TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', ProfileId='00e1a000000VfUqAAK', LanguageLocaleKey='en_US');
        
        System.runAs(testUser) {
            MatrixTabController controller = new MatrixTabController(); 
            System.assertEquals(testUser.Id, controller.currentuser.id);
            System.assertEquals('https://www.matrixlms.com/app/launch?salesforce=true&salesforce_userid='+testUser.Id, controller.iframe_src);
            
            matrixlms__Matrix_Setting__c portalUrl = new matrixlms__Matrix_Setting__c(Name='portalUrl', matrixlms__Value__c='https://sandbox.matrixlms.com/?salesforce=true');
            insert portalUrl;
            MatrixTabController controller2 = new MatrixTabController(); 
            System.assertEquals('https://sandbox.matrixlms.com/?salesforce=true&salesforce_userid='+testUser.Id, controller2.iframe_src);
        }
        
        User testUser2 = new User(Username='test_matrixlms_15052016@test.com', matrixlms__Matrix_Userid__c='178023', matrixlms__Matrix_Username__c='test_student', matrixlms__Matrix_Password__c='123456', Email='test@test.com', Alias='test', LastName='test', CommunityNickname='test12', TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', ProfileId='00e1a000000VfUqAAK', LanguageLocaleKey='en_US');
        System.runAs(testUser2) {
            MatrixTabController controller3 = new MatrixTabController(); 
            System.assertEquals('https://sandbox.matrixlms.com/log_in/submit?userid=test_student&password=123456&salesforce=true&salesforce_userid='+testUser2.Id, controller3.iframe_src);
        }
    }
    
}