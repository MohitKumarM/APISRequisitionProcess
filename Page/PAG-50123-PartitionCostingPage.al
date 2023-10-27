page 50123 "Partition Costing"
{
    ApplicationArea = All;
    Caption = 'Partition Costing';
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "CZ Header";
    SourceTableView = where(Type = filter(Partition));
    InsertAllowed = true;
    AutoSplitKey = true;
    MultipleNewLines = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("Product No."; Rec."Product No.")
                {
                    ToolTip = 'Specifies the value of the Product No. field.';
                    Editable = false;
                    ShowMandatory = true;
                }

                field("Vendor Code"; Rec."Vendor Code")
                {
                    ToolTip = 'Specifies the value of the Vendor Code field.';
                    ShowMandatory = true;
                    Editable = false;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    TableRelation = Vendor.Name;
                    Editable = false;
                }
                field("Main Item Code"; Rec."Main Item Code")
                {
                    ToolTip = 'Specifies the value of the Main Item Code field.';
                    ShowMandatory = true;
                    Editable = false;
                }
                field("Main Item Name"; Rec."Main Item Name")
                {
                    ToolTip = 'Specifies the value of the Main Item Name field.';
                    Editable = false;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Start Date field.';
                    ShowMandatory = true;
                    Editable = false;
                }
                field("End date"; Rec."End date")
                {
                    ToolTip = 'Specifies the value of the End date field.';
                    ShowMandatory = true;
                    Editable = false;
                }
                field("Length Inch"; Rec."Length Inch")
                {
                    ToolTip = 'Specifies the value of the Length Inch field.';
                }
                field("Length MM"; Rec."Length MM")
                {
                    ToolTip = 'Specifies the value of the Length MM field.';
                    trigger OnValidate()
                    begin
                        CalculatePartitionCosting();
                    end;
                }
                field("Width Inch"; Rec."Width Inch")
                {
                    ToolTip = 'Specifies the value of the Width Inch field.';
                }
                field("Width MM"; Rec."Width MM")
                {
                    ToolTip = 'Specifies the value of the Width MM field.';
                    trigger OnValidate()
                    begin
                        CalculatePartitionCosting();
                    end;
                }
                field("Height Inch"; Rec."Height Inch")
                {
                    ToolTip = 'Specifies the value of the Height Inch field.';
                }
                field("Height MM"; Rec."Height MM")
                {
                    ToolTip = 'Specifies the value of the Height MM field.';
                    trigger OnValidate()
                    begin
                        CalculatePartitionCosting();
                    end;
                }
                field("Total Length"; Rec."Total Length")
                {
                    ToolTip = 'Specifies the value of the Total Length field.';
                    Editable = false;
                }
                field("Total Width"; Rec."Total Width")
                {
                    ToolTip = 'Specifies the value of the Total Width field.';
                    Editable = false;
                }
                field(Conversion; Rec.Conversion)
                {
                    ToolTip = 'Specifies the value of the Conversion field.';
                    trigger OnValidate()
                    begin
                        CalculatePartitionCosting();
                    end;
                }
                field("Conversion Price"; Rec."Conversion Price")
                {
                    Editable = false;
                }
                field(Printing; Rec.Printing)
                {
                    ToolTip = 'Specifies the value of the Printing field.';
                    trigger OnValidate()
                    begin
                        CalculatePartitionCosting();
                    end;
                }
                field("Rate Per Box/PCs"; Rec."Rate Per Box/PCs")
                {
                    ToolTip = 'Specifies the value of the Rate Per Box/PCs field.';
                    Editable = false;
                }
                field("No. of Pcs"; Rec."No. of Pcs")
                {
                    trigger OnValidate()
                    begin
                        CalculatePartitionCosting();
                    end;
                }
                field("Total Cost"; Rec."Total Cost")
                {
                    Editable = false;
                }

            }
            part(PartitionLines; "Partition Lines")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "Product No." = field("Product No."), Type = field(Type), "Type Line No." = field("Type Line No."), "Vendor Code" = field("Vendor Code"), "Start Date" = field("Start Date"), "End date" = field("End date");
                UpdatePropagation = Both;
            }
        }
    }
    trigger OnOpenPage()
    begin
        CalculatePartitionCosting();
    end;

    trigger OnAfterGetRecord()
    begin
        CalculatePartitionCosting();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        IF (Rec."Type Line No." > 0) then
            CurrPage.PartitionLines.Page.SetTypeLineNo(Rec."Type Line No.");
        CalculatePartitionCosting();
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        CZHeader_Loc: Record "CZ Header";
        CZHeader_Loc2: Record "CZ Header";
    begin
        IF (Rec."Product No." <> '') then begin
            CZHeader_Loc.Reset();
            CZHeader_Loc.SetRange(Type, CZHeader_Loc.Type::Carton);
            CZHeader_Loc.SetRange("Product No.", Rec."Product No.");
            IF CZHeader_Loc.FindFirst() then begin
                Rec."Vendor Code" := CZHeader_Loc."Vendor Code";
                Rec."Main Item Code" := CZHeader_Loc."Main Item Code";
                Rec."Main Item Name" := CZHeader_Loc."Main Item Name";
                Rec."Start Date" := CZHeader_Loc."Start Date";
                Rec."End date" := CZHeader_Loc."End date";
                CZHeader_Loc2.Reset();
                CZHeader_Loc2.SetRange(Type, Rec.Type);
                CZHeader_Loc2.SetRange("Product No.", Rec."Product No.");
                CZHeader_Loc2.SetRange("Vendor Code", Rec."Vendor Code");
                CZHeader_Loc2.SetRange("Main Item Code", Rec."Main Item Code");
                CZHeader_Loc2.SetRange("Start Date", Rec."Start Date");
                CZHeader_Loc2.SetRange("End date", Rec."End date");
                IF CZHeader_Loc2.FindLast() then
                    Rec."Type Line No." := CZHeader_Loc2."Type Line No." + 10000
                else
                    Rec."Type Line No." := 10000;


                CurrPage.PartitionLines.Page.SetTypeLineNo(Rec."Type Line No.");
            end;
        end;

    end;

    procedure CalculatePartitionCosting()
    begin
        Rec."Total Length" := (Rec."Length MM" + Rec."Width MM");
        Rec."Total Width" := (Rec."Width MM" + Rec."Height MM");


        Rec.CalcFields(TotalLinePrice, TotalLineSheetWeightGM);
        Rec."Conversion Price" := (Rec.Conversion * Rec.TotalLineSheetWeightGM);
        Rec."Rate Per Box/PCs" := (Rec."Conversion Price" + Rec.Printing + Rec.TotalLinePrice);
        Rec."Total Cost" := Rec."Rate Per Box/PCs" * Rec."No. of Pcs";

        IF Rec.Modify() then;
        CurrPage.Update(true);
    end;

}
