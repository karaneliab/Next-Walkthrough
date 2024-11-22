codeunit 43132 "Next Workflow Response Handlin"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', false, false)]
    local procedure OnOpenDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        Next: Record "Next WalkThrough";
        ReleaseDoc: Codeunit "Doc Release";

    begin
        case RecRef.Number of
            DATABASE::"Next WalkThrough":
                begin
                    // RecRef.SetTable(Next);
                    // Next.Validate(Status, Next.Status::Created);
                    // Handled := true;
                    // Next.Modify(true)
                    Next.SetView(RecRef.GetView());
                    Handled := true;
                    ReleaseDoc.NextReopen(Next);
                end;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', false, false)]
    local procedure OnReleaseDocument(RecRef: RecordRef; var Handled: Boolean)
    VAR
        Next: Record "Next WalkThrough";
        VarVariant: Variant;
    begin
        VarVariant := RecRef;
        Case
        RecRef.Number of
            Database::"Next WalkThrough":
                begin
                    RecRef.SetTable(Next);
                    Next.Validate(Status, Next.Status::Approved);
                    Next.Modify(true);
                    Handled := true;
                End;
        end;
    end;

}
