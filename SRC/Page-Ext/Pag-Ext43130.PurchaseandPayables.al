pageextension 43130 "Purchase and Payables" extends "Purchases & Payables Setup"
{
    layout
    {
        addafter("Order Nos.")
        {
            field("Next Walk Through Nos."; Rec."Next Walk Through Nos.")
            {
                Caption = 'Next Walk Through Nos.';
                ApplicationArea = All;

            }
        }
    }
}
