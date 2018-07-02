/**
*  This class is test class for clsscheduled_UpdatePlantSurveyScore.
*
@author Pankaj Raijade
@created 4/2/2015
@version 1.0   
@since 33.0
*
@changelog
* coverage  93%
* 
* 
4/2/2015 Pankaj Raijade pankaj.raijade@zensar.in
* - Created
*/
@istest(seeAlldata=false)
public class clsscheduled_UpdatePlantSurveyScore_test
{
    static testmethod void clsscheduled_UpdatePlantSurveyScore_TM()
    {
        DateTime currTime = DateTime.now();
        Integer min = currTime.minute();
        Integer hour = currTime.hour();
        String sch;
        
        if(min <= 58)
            sch = '0 '+ (min + 1) + ' ' + hour + ' * * ? '+ currTime.year();
        else          
            sch = '0 0 '+ (hour + 1) + ' * * ? '+ currTime.year();
        clsscheduled_UpdatePlantSurveyScore o = new clsscheduled_UpdatePlantSurveyScore();
        test.starttest();
            System.schedule('ScheduleUpdatePlantSurveyScoretest', sch,o);
            Batch_size_setting__c oBatchsize = new Batch_size_setting__c(name = 'clsBatch_UpdatePlantSurveyScore', Batch_size__c = 100);
            insert oBatchsize;
            o = new clsscheduled_UpdatePlantSurveyScore();
            System.schedule('ScheduleUpdatePlantSurveyScoretest2', sch,o);    
        test.stoptest();
    }
}