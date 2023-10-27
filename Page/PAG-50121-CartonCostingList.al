page 50121 "Carton Costing List"
{
    ApplicationArea = All, Basic, Suite;
    ;
    Caption = 'Carton Costing Master';
    CardPageId = "Carton Costing";
    DataCaptionFields = "Product No.", "Main Item Name", "Vendor Name";
    Editable = false;
    PageType = List;
    SourceTable = "CZ Header";
    SourceTableView = where(Type = filter(Carton));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Product No."; Rec."Product No.")
                {
                    ToolTip = 'Specifies the value of the Product No. field.';
                }
                field("Item Name"; Rec."Main Item Name")
                {
                    ToolTip = 'Specifies the value of the Main Item Name field.';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ToolTip = 'Specifies the value of the Vendor Name field.';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Start Date field.';
                }
                field("End date"; Rec."End date")
                {
                    ToolTip = 'Specifies the value of the End date field.';
                }
                field("Total Cost"; Rec."Total Cost") { }
            }
        }
    }
    var

    trigger OnOpenPage()
    begin
        CalculateCartonCostingHeader();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CalculateCartonCostingHeader();
    end;

    trigger OnAfterGetRecord()
    begin
        CalculateCartonCostingHeader();
    end;


    procedure CalculateCartonCostingHeader()
    var
        CZHeader_Loc1: Record "CZ Header";
    begin
        Rec."Total Length" := Rec."Length MM" + Rec."Length MM" + Rec."Width MM" + Rec."Width MM" + 38 + 10;
        Rec."Total Width" := Rec."Width MM" + Rec."Height MM" + 10;

        Rec.CalcFields(TotalLinePrice, TotalLineSheetWeightGM);
        Rec."Conversion Price" := (Rec.Conversion * Rec.TotalLineSheetWeightGM);
        Rec."Rate Per Box/PCs" := (Rec."Conversion Price" + Rec.Printing + Rec.TotalLinePrice);

        CZHeader_Loc1.Reset();
        CZHeader_Loc1.SetRange("Product No.", Rec."Product No.");
        CZHeader_Loc1.SetFilter(Type, '%1|%2 ', CZHeader_Loc1.Type::Partition, CZHeader_Loc1.Type::Plate);
        IF CZHeader_Loc1.FindSet() then begin
            Rec."Total Cost" := 0;
            repeat
                Rec."Total Cost" += Round(CZHeader_Loc1."Total Cost", 0.01, '=');
            until CZHeader_Loc1.Next() = 0;
            Rec."Total Cost" += Rec."Rate Per Box/PCs";
        end;


    end;
}
