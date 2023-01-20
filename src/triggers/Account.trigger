/**
 * @description       : 
 *                      
 * @author            : hyunsoo.song@daeunextier.com
 * @group             :
 * @last modified on  : 2023-01-09
 * @last modified by  : hyunsoo.song@daeunextier.com
 * Modifications Log
 * Ver     Date             Author                  Modification
 * 1.0   2023-01-09   hyunsoo.song@daeunextier.com   Initial Version
 */
trigger Account on Account (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    new Account_tr().run();
}