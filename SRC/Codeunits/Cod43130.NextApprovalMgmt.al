codeunit 43130 "Next Approval Mgmt."
{
    procedure CheckNextWalkThroughWorkflowEnabled(var Next: Record "Next WalkThrough"): Boolean
    begin
        if not IsWorkflowEnabled(Next) then
            Error(NoWorkflowEnabledErr);
        exit(true)
    end;

    procedure IsWorkflowEnabled(var Next: Record "Next WalkThrough"): Boolean
    begin
        exit(WorkflowMgmt.CanExecuteWorkflow(Next, WorkflowEventHandling.RunOnsendNextWalkthroughForApprovalCode));
    end;

    [IntegrationEvent(false, false)]
    procedure OnsendNextWalkthroughForApproval(var Next: Record "Next WalkThrough")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelNextWalkthroughForApprovalRequest(var Next: Record "Next WalkThrough")
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', false, false)]
    procedure RunOnPopulateApprovalEntryArgument(var ApprovalEntryArgument: Record "Approval Entry"; var RecRef: RecordRef; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        Next: Record "Next WalkThrough";
    begin
        if RecRef.Number = Database::"Next WalkThrough" then begin
            Recref.SetTable(Next);
            ApprovalEntryArgument."Table ID" := RecRef.Number;
            ApprovalEntryArgument."Document No." := Next."No.";
            ApprovalEntryArgument.INSERT()
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', false, false)]
    procedure OnSetStatusToPendingApproval(RecRef: RecordRef; var IsHandled: Boolean; var Variant: Variant)
    var
        Next: Record "Next WalkThrough";
    begin
        case
         RecRef.Number of
            Database::"Next WalkThrough":
                begin
                    RecRef.SetTable(Next);
                    Next.Validate(Status, Next.Status::"Approved");
                    Next.Modify(true);
                    IsHandled := true;
                    Variant := Next;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', false, false)]
    procedure OnRejectApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    var
        Next: Record "Next WalkThrough";
        Recref: RecordRef;
    begin
        Recref.Get(ApprovalEntry."Record ID to Approve");
        case
            Recref.Number of
            Database::"Next WalkThrough":
                begin
                    Recref.SetTable(Next);
                    //Next.Validate(Status, Next.Status::Rejected);
                    Next.Status := Next.Status::Rejected;
                    Next.Modify(true);
                end;
        end;

    end;

    var
        NoWorkflowEnabledErr: Label 'No Approval workflow for this record type is enabled';
        WorkflowMgmt: Codeunit "Workflow Management";
        WorkflowEventHandling: Codeunit "Next Workflow Event Handling";
}
