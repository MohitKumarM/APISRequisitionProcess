page 50124 "Partition Lines"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    Caption = 'Partition Lines';
    RefreshOnActivate = true;
    PageType = ListPart;
    ApplicationArea = All, Basic, Suite;
    UsageCategory = Lists;
    SourceTable = "CZ Lines";
    SourceTableView = where(Type = filter(Partition));

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Item Code"; Rec."Quality Paper Code")
                {

                }
                field("Item Name"; Rec."Quality Paper Description")
                {

                }
                field(Length; Rec.Length)
                {
                    ToolTip = 'Specifies the value of the Length field.';
                    trigger OnValidate()
                    begin
                        CalculatePartionLineCosting();
                    end;
                }
                field(Width; Rec.Width)
                {
                    ToolTip = 'Specifies the value of the Width field.';
                    trigger OnValidate()
                    begin
                        CalculatePartionLineCosting();
                    end;
                }
                field("Area (Sq Mtr)"; Rec."Area (Sq Mtr)")
                {
                    ToolTip = 'Specifies the value of the Area (Sq Mtr) field.';
                    Editable = false;
                }
                field(GSM; Rec.GSM)
                {
                    ToolTip = 'Specifies the value of the GSM field.';
                    trigger OnValidate()
                    begin
                        CalculatePartionLineCosting();
                    end;
                }
                field("Box GSM"; Rec."Box GSM")
                {
                    ToolTip = 'Specifies the value of the Box GSM field.';
                    Editable = false;
                }
                field("Wastage 4%"; Rec."Wastage 4%")
                {
                    ToolTip = 'Specifies the value of the Wastage 4% field.';
                    Editable = false;
                }
                field("Sheet Weight (GM)"; Rec."Sheet Weight (GM)")
                {
                    ToolTip = 'Specifies the value of the Sheet Weight (GM) field.';
                    Editable = false;
                }
                field("Rate of Papar"; Rec."Rate of Papar")
                {
                    ToolTip = 'Specifies the value of the Rate of Papar field.';
                    trigger OnValidate()
                    begin
                        CalculatePartionLineCosting();
                    end;
                }
                field(Price; Rec.Price)
                {
                    ToolTip = 'Specifies the value of the Price field.';
                    Editable = false;
                }

            }
            group(Control51)
            {
                ShowCaption = false;
                group(Control45)
                {
                    ShowCaption = false;

                    field("Total Line Price"; TotalLinePrice)
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = false;
                    }
                }
            }
        }
    }

    var
        TotalLinePrice: Decimal;
        Glob_TypeLineNo: Integer;

    trigger OnOpenPage()
    begin
        CalculatePartionLineCosting();
    end;

    trigger OnAfterGetRecord()
    begin
        CalculatePartionLineCosting();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CalculatePartionLineCosting();
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Type Line No." := Glob_TypeLineNo;
    end;

    procedure SetTypeLineNo(TypeLinenO_Loc: Integer)
    begin
        Glob_TypeLineNo := TypeLinenO_Loc;
    end;

    procedure CalculatePartionLineCosting()
    var
        CZHeader_Loc: Record "CZ Header";
    begin
        Rec."Area (Sq Mtr)" := ((Rec.Length * Rec.Width) / 1000000);
        Rec."Box GSM" := ((Rec.GSM * Rec."Area (Sq Mtr)") / 1000);
        Rec."Wastage 4%" := (Rec."Box GSM" * 0.04);
        Rec."Sheet Weight (GM)" := (Rec."Box GSM" + Rec."Wastage 4%");
        Rec.Price := (Rec."Rate of Papar" * Rec."Sheet Weight (GM)");


        CZHeader_Loc.Reset();
        CZHeader_Loc.SetRange("Product No.", Rec."Product No.");
        CZHeader_Loc.SetRange(Type, Rec.Type);
        CZHeader_Loc.SetRange("Type Line No.", Rec."Type Line No.");
        IF CZHeader_Loc.FindFirst() then begin
            CZHeader_Loc.CalcFields(TotalLinePrice, TotalLineSheetWeightGM);
            TotalLinePrice := CZHeader_Loc.TotalLinePrice;

            CZHeader_Loc."Conversion Price" := (CZHeader_Loc.Conversion * CZHeader_Loc.TotalLineSheetWeightGM);
            CZHeader_Loc."Rate Per Box/PCs" := (CZHeader_Loc."Conversion Price" + CZHeader_Loc.Printing + CZHeader_Loc.TotalLinePrice);
            IF CZHeader_Loc.Modify() then;

        end;
        IF Rec.Modify() then;


    end;
}
