codeunit 43133 "Doc Release"
{
    [IntegrationEvent(false, false)]
    local procedure OnBeforeReopenNext(var Next: Record "Next WalkThrough")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReopenNext(var Next: Record "Next WalkThrough")
    begin
    end;

    procedure NextReopen(var Next: Record "Next WalkThrough")
    begin
        OnBeforeReopenNext(Next);
        if Next.Status = Next.Status::Created then
            exit;
        next.Status := Next.Status::Created;
        next.modify(true);
        OnAfterReopenNext(Next);

    end;
}
