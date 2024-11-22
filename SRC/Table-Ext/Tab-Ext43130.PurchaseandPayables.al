tableextension 43130 "Purchase and Payables" extends "Purchases & Payables Setup"
{
    fields
    {
        field(43130; "Next Walk Through Nos.";code[20])
        {
            Caption = 'Next Walk Through Nos.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
    }
}
