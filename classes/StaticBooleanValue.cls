/**
 * 
 *   This class is used in "bucketAccountupdate" trigger and "BatchCls_DeleteSObjects" batch class. 
    Purpose of this class is to bypass the "BucketAccountUpdate" Trigger while "BatchCls_DeleteSObjects" batch process is running using static boolean value.
 * Please refer to project in teamup: 'C2S Archive and Delete Cases'
 *
 * @author      Srinath Thallapally
 * @created     2016-16-09
 * @since      36.0     
 * @version     1.0                                                                
 * 
 * @changelog
 * 2016-16-09 Srinath Thallapally <srinath.thallapally@te.com>
 * - Created
 *    
 */
 
 public class StaticBooleanValue {

   Public static boolean checkflag = true;

}