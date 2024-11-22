codeunit 43131 "Next Workflow Event Handling"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Next Approval Mgmt.", 'OnsendNextWalkthroughForApproval', '', false, false)]
    procedure RunOnsendNextWalkthroughForApproval(var Next: Record "Next WalkThrough")
    begin
        WorkflowMgmt.HandleEvent(RunOnsendNextWalkthroughForApprovalCode, Next);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Next Approval Mgmt.", 'OnCancelNextWalkthroughForApprovalRequest', '', false, false)]
    procedure RunOnCancelNextWalkthroughForApprovalRequest(var Next: Record "Next WalkThrough")
    begin
        WorkflowMgmt.HandleEvent(RunOnCancelNextWalkthroughForApprovalRequestCode, Next);
    end;

    procedure RunOnsendNextWalkthroughForApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunOnsendNextWalkthroughForApproval'));
    end;

    procedure RunOnCancelNextWalkthroughForApprovalRequestCode(): Code[128]
    begin
        exit(UpperCase('RunOnCancelNextWalkthroughForApprovalRequest'));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    procedure OnAddWorkflowEventsToLibrary()
    begin
        WorkflowEventHandling.AddEventToLibrary(RunOnsendNextWalkthroughForApprovalCode, Database::"Next WalkThrough",
        NextWalkThroughSendForApprovalEventDescTxt, 0, false);

        WorkflowEventHandling.AddEventToLibrary(RunOnCancelNextWalkthroughForApprovalRequestCode, Database::"Next WalkThrough",
        NextWalkThroughCancelForApprovalRequestEventDescTxt, 0, false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', false, false)]
    procedure OnAddWorkflowEventPredecessorsToLibrary(EventFunctionName: Code[128])
    begin
        case
            EventFunctionName of
            RunOnCancelNextWalkthroughForApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunOnCancelNextWalkthroughForApprovalRequestCode, RunOnsendNextWalkthroughForApprovalCode);
            RunOnsendNextWalkthroughForApprovalCode:
                WorkflowEventHandling.AddEventPredecessor(RunOnCancelNextWalkthroughForApprovalRequestCode, RunOnsendNextWalkthroughForApprovalCode);
        end;
    end;

    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowMgmt: Codeunit "Workflow Management";

        PendingApprovalMsg: Label 'An Approval request for Next Walkthrough has been sent';

        WalkthroghReleased: Label 'Next WalkThrough Is Released';
        NextWalkThroughCancelForApprovalRequestEventDescTxt: Label 'An Approval request for Next Approval Walkthrough is cancelled.';
        NextWalkThroughSendForApprovalEventDescTxt: Label 'An Approval request for Next Approval walkthrough is requested.';
}
