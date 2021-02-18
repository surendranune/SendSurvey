({
    doInit : function(component, event, helper) {
        var action = component.get('c.sendSurvey');
        action.setParams({conId: component.get('v.recordId')});
        action.setCallback(this, function(response){
            component.set('v.isSent', true);
            
            window.setTimeout(
                $A.getCallback(function() {
                    $A.get("e.force:closeQuickAction").fire();
                    $A.get('e.force:refreshView').fire();
                }), 3000
            );
            
        });
        window.setTimeout(
                $A.getCallback(function() {
                    $A.enqueueAction(action);
                }), 1000
            );
    }
})