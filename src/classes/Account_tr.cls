/**
 * @description       : 
 *                      
 * @author            : hyunsoo.song@daeunextier.com
 * @group             :
 * @last modified on  : 2023-01-09
 * @last modified by  : myhuo
 * Modifications Log
 * Ver     Date             Author                    Modification
 * 1.0   2023-01-09   hyunsoo.song@daeunextier.com   Initial Version
 */
public with sharing class Account_tr {
    private Map<Id, Contact> mapContactUpdate = new Map<Id, Contact>();

    List<Account> listNew = Trigger.new;
    List<Account> listOld = Trigger.old;
    Map<Id, Account> mapNew = (Map<Id, Account>) Trigger.newMap;
    Map<Id, Account> mapOld = (Map<Id, Account>) Trigger.oldMap;

    public void run() {
        if (Trigger.isBefore && Trigger.isInsert) beforeInsert();
        else if (Trigger.isBefore && Trigger.isUpdate) beforeUpdate();
        else if (Trigger.isBefore && Trigger.isDelete) beforeDelete();
        else if (Trigger.isAfter && Trigger.isInsert) afterInsert();
        else if (Trigger.isAfter && Trigger.isUpdate) afterUpdate();
        else if (Trigger.isAfter && Trigger.isDelete) afterDelete();
        else if (Trigger.isAfter && Trigger.isUndelete) afterUndelete();
    }

    private void beforeInsert() {
    }

    private void beforeUpdate() {
    }

    private void beforeDelete() {
    }

    private void afterInsert() {
    }

    private void afterUpdate() {
        updateContactPhone();

        if (!mapContactUpdate.isEmpty()) update mapContactUpdate.values();
    }

    private void afterDelete() {
    }

    private void afterUndelete() {
    }

    private void updateContactPhone () {
        Set<Id> setAccIds = new Set<Id>();

        for(Account obj : listNew) {
            setAccIds.add(obj.Id);
            System.debug('[acc_tr] accountId : ' + setAccIds);
        }

        if(!setAccIds.isEmpty()) {
            for(Contact objContact : [
                    SELECT Phone
                    FROM Contact
                    WHERE AccountId IN: setAccIds
            ]) {
                objContact.Phone = '0101234567' + Opportunity_tr.cnt;
                mapContactUpdate.put(objContact.Id, objContact);
                System.debug('[acc_tr] contact phone : ' + objContact.Phone);
            }
        }
    }
}