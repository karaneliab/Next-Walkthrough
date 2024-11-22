table 43130 "Next WalkThrough"
{
    Caption = 'Next WalkThrough';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
            Editable = false;
            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    Purch.Get();
                    purch.TestField("Next Walk Through Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; Name; Text[250])
        {
            Caption = 'Name';
        }
        field(3; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(4; "Date"; Date)
        {
            Caption = 'Date';
        }
        field(5; "Date Modified"; DateTime)
        {
            Caption = 'Last  Date';
            Editable = false;

        }
        field(6; Status; Enum "Approval Status")
        {
            Caption = 'Approval Status';
            Editable = false;

            DataClassification = CustomerContent;
        }
        field(7; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = Microsoft.Foundation.NoSeries."No. Series";
        }

    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        Purch.Get();
        Purch.TestField("Next Walk Through Nos.");
        if "No." = '' then
            "No." := NooSerie.GetNextNo(PURCH."Next Walk Through Nos.", Today);
    end;

    local procedure TestOnRelease()
    begin
        if Status <> Status::Approved then
            exit;

        "Date Modified" := CurrentDateTime;
    end;


    var
        Purch: Record "Purchases & Payables Setup";
        NooSerie: Codeunit "No. Series";
}
