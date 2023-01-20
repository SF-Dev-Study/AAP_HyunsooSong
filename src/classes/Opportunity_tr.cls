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

public with sharing class Opportunity_tr {
    public static Integer cnt = 0;
    private Map<Id, Account> mapAccountUpdate = new Map<Id, Account>();

    List<Opportunity> listNew = Trigger.new;
    List<Opportunity> listOld = Trigger.old;
    Map<Id, Opportunity> mapNew = (Map<Id, Opportunity>) Trigger.newMap;
    Map<Id, Opportunity> mapOld = (Map<Id, Opportunity>) Trigger.oldMap;

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
        updateAccountName();

        if (!mapAccountUpdate.isEmpty()) update mapAccountUpdate.values();
    }

    private void beforeUpdate() {
    }

    private void beforeDelete() {
    }

    private void afterInsert() {
    }

    // before event 시, flow에서 업데이트 시도하는 레코드와 duplicate 되어서 flow로 record 업데이트 한 후에 트리거 업데이트를 해야함. -> after event
    private void afterUpdate() {
        updateAccountName();

        if (!mapAccountUpdate.isEmpty()) update mapAccountUpdate.values();
    }

    private void afterDelete() {
    }

    private void afterUndelete() {
    }

    private void updateAccountName () {
        Set<Id> setAccIds = new Set<Id>();

        for(Opportunity obj : listNew){
            if(obj.AccountId != null) setAccIds.add(obj.AccountId);
            System.debug('[opp_tr] accountId : ' + obj.AccountId);
        }

        if(!setAccIds.isEmpty()) {
            for(Account objAcc : [
                    SELECT Name
                    FROM Account
                    WHERE Id IN: setAccIds
            ]) {
                objAcc.Name = 'Test Execution ' + ++cnt;
                mapAccountUpdate.put(objAcc.Id, objAcc);
                System.debug('[opp_tr] account name : ' + objAcc.Name);
            }
        }
    }

}