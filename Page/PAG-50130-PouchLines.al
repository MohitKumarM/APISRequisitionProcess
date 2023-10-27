page 50130 "Pouch Lines"
{

    Caption = 'Pouch Lines';
    PageType = ListPart;
    SourceTable = "CZ Lines";
    SourceTableView = where(Type = filter(Pouch));
    AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    ApplicationArea = All;
    // UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Material; Rec."Quality Paper Code")
                {
                    trigger OnValidate()
                    begin
                        CalculatePouchLineCosting();
                    end;
                }
                field(Micron; Rec.Micron)
                {
                    trigger OnValidate()
                    begin
                        CalculatePouchLineCosting();
                    end;

                }
                field(Density; Rec.Density)
                {
                    trigger OnValidate()
                    begin
                        CalculatePouchLineCosting();
                    end;
                }
                field(GSM; Rec.GSM)
                {
                    Editable = false;
                }
                field("Rate(Rs/Kg)"; Rec."Rate(Rs/Kg)")
                {
                    trigger OnValidate()
                    begin
                        CalculatePouchLineCosting();
                    end;
                }
                field(Conspt; Rec.Conspt)
                {
                    Editable = false;
                }
                field("Cost/Pouch"; Rec."Cost/Pouch")
                {
                    Editable = false;
                }
                field("Total Rs"; Rec."Total Rs")
                {
                    Editable = false;
                }

            }
            group(Control51)
            {
                ShowCaption = false;
                group(Control45)
                {
                    ShowCaption = false;

                    field("Total GSM"; CZ_Header_Loc.PouchTotalGSM)
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = false;
                    }
                    field("Total Conspt"; CZ_Header_Loc.PouchTotalConspt)
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = false;
                    }
                    field("Total Cost/Pouch"; CZ_Header_Loc.PouchTotalCostPerPouch)
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = false;
                    }
                    field("Total of Total Rs"; CZ_Header_Loc.PouchLineTotalRs)
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = false;
                    }
                }
            }
        }
    }
    var
        CZ_Header_Loc: Record "CZ Header";

    trigger OnOpenPage()
    begin
        CalculatePouchLineCosting();
    end;

    trigger OnAfterGetRecord()
    begin
        CalculatePouchLineCosting();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CalculatePouchLineCosting();
    end;

    procedure CalculatePouchLineCosting()
    var

    begin
        Rec.GSM := (Rec.Micron * Rec.Density);

        CZ_Header_Loc.Reset();
        CZ_Header_Loc.SetRange("Product No.", Rec."Product No.");
        CZ_Header_Loc.SetRange(Type, Rec.Type);
        IF CZ_Header_Loc.FindFirst() then
            CZ_Header_Loc.CalcFields(PouchTotalGSM, PouchTotalConspt, PouchTotalCostPerPouch, PouchLineTotalRs);

        IF (CZ_Header_Loc."Material in Sq. mm" <> 0) then
            Rec.Conspt := ((Rec.GSM * CZ_Header_Loc."Material in Sq. mm") / 1000000)
        else
            Rec.Conspt := 0;

        Rec."Cost/Pouch" := ((Rec.Conspt * Rec."Rate(Rs/Kg)") / 1000);

        Rec."Total Rs" := (Rec."Cost/Pouch" * CZ_Header_Loc."Pouches in Sq. M" * 1000);
        If Rec.Modify() then;
    end;
}

