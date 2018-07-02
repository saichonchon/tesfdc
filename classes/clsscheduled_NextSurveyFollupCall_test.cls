/**
*  This class is used as test class for clsscheduled_NextSurveyFollupCallRem
*
@author Pankaj Raijade
@created 1/2/2016
@changelog

*/
@istest(seeAlldata=false)
public class clsscheduled_NextSurveyFollupCall_test
{
    static testmethod void clsscheduled_NextSurveyFollupCall_TM()
    {
        DateTime currTime = DateTime.now();
        Integer min = currTime.minute();
        Integer hour = currTime.hour();
        String sch;
        
        if(min <= 58)
            sch = '0 '+ (min + 1) + ' ' + hour + ' * * ? '+ currTime.year();
        else          
            sch = '0 0 '+ (hour + 1) + ' * * ? '+ currTime.year();
        clsscheduled_NextSurveyFollupCallRem o = new clsscheduled_NextSurveyFollupCallRem ();
        test.starttest();
            System.schedule('clsscheduled_NextSurveyFollupCallRem' + DateTime.now(), sch,o); 
        test.stoptest();
    }
}