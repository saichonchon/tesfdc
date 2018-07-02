/**********************************************************************
Name: ADMAggregateResultIterable
Copyright © 2017
==========================================================================================================
==========================================================================================================
Purpose: ADMAggregateResultIterable is implements Iterable                                                        
======================================================
======================================================
History                                                            
-------                                                            
VERSION      AUTHOR               DATE             DETAIL Description
0.1          Vaibhav  M           11/20/2017       INITIAL DEVELOPMENT
***********************************************************************/
global class ADMAggregateResultIterable implements Iterable<AggregateResult>{
 
global Iterator<AggregateResult> Iterator(){ 
    return new ADMAggregateResultIterator(); 
    } 
}