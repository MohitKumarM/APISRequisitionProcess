page 50115 BottleCostingMaster
{
    ApplicationArea = All;
    Caption = 'Bottle Costing Master';
    PageType = List;
    SourceTable = "BCL Costing Master";
    SourceTableView = where(Type = filter(Bottle));
    UsageCategory = Lists;
    DelayedInsert = true;


    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Vendor Code"; Rec."Vendor Code")
                {
                    ToolTip = 'Specifies the value of the Vendor Code field.';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {

                }
                field("Item Code"; Rec."Item Code")
                {
                    ToolTip = 'Specifies the value of the Item Code field.';
                }
                field("Item Name"; Rec."Item Name")
                {
                    ToolTip = 'Specifies the value of the Item Name field.';
                }
                field("Unit of Production for PO"; Rec."Unit of Production for PO")
                {

                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Start Date field.';
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field.';

                }
                field("Weight (in Grams)"; Rec."Weight (in Grams)")
                {
                    ToolTip = 'Specifies the value of the Weight (in Grams) field.';
                    trigger OnValidate()
                    begin
                        CalculateBottleCosting();
                    end;
                }
                field("Neck Size"; Rec."Neck Size")
                {
                    ToolTip = 'Specifies the value of the Neck Size field.';
                    trigger OnValidate()
                    begin
                        CalculateBottleCosting();
                    end;
                }
                field("Resin price (RELPET G 5801)/kg"; Rec."Resin price (RELPET G 5801)/kg")
                {
                    ToolTip = 'Specifies the value of the Resin price (RELPET G 5801)/kg field.';
                    trigger OnValidate()
                    begin
                        CalculateBottleCosting();
                    end;
                }
                field("Preform conversion/kg"; Rec."Preform conversion/kg")
                {
                    ToolTip = 'Specifies the value of the Preform conversion/kg field.';
                    trigger OnValidate()
                    begin
                        CalculateBottleCosting();
                    end;
                }
                field("Blowing conversion/kg"; Rec."Blowing conversion/kg")
                {
                    ToolTip = 'Specifies the value of the Blowing conversion/kg field.';
                    trigger OnValidate()
                    begin
                        CalculateBottleCosting();
                    end;
                }
                field("Total Conversion per kg"; Rec."Total Conversion per kg")
                {
                    ToolTip = 'Specifies the value of the Total Conversion per kg field.';
                    Editable = false;

                }
                field("Total Per kg"; Rec."Total Per kg")
                {
                    ToolTip = 'Specifies the value of the Total Per kg field.';
                    Editable = false;

                }
                field("Bottle/Jar cost"; Rec."Bottle/Jar cost")
                {
                    ToolTip = 'Specifies the value of the Bottle/Jar cost field.';
                    Editable = false;

                }
                field("Packing ( CFC- 3 ply)"; Rec."Packing ( CFC- 3 ply)")
                {
                    ToolTip = 'Specifies the value of the Packing ( CFC- 3 ply) field.';
                    trigger OnValidate()
                    begin
                        CalculateBottleCosting();
                    end;
                }
                field("Individual poly bag"; Rec."Individual poly bag")
                {
                    ToolTip = 'Specifies the value of the Individual poly bag field.';
                    trigger OnValidate()
                    begin
                        CalculateBottleCosting();
                    end;
                }
                field("Freight till Apis ( Manglore)"; Rec."Freight till Apis ( Manglore)")
                {
                    ToolTip = 'Specifies the value of the Freight till Apis ( Manglore) field.';
                    trigger OnValidate()
                    begin
                        CalculateBottleCosting();
                    end;
                }
                field("Total Cost"; Rec."Total Cost")
                {
                    ToolTip = 'Specifies the value of the Total Cost field.';
                    Editable = false;

                }

            }
        }
    }
    trigger OnOpenPage()
    begin
        CalculateBottleCosting();
    end;

    trigger OnAfterGetRecord()
    begin
        CalculateBottleCosting();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CalculateBottleCosting();
    end;

    local procedure CalculateBottleCosting()
    var
    begin

        Rec."Total Conversion per kg" := (Rec."Preform conversion/kg" + Rec."Blowing conversion/kg");
        Rec."Total Per kg" := (Rec."Resin price (RELPET G 5801)/kg" + Rec."Total Conversion per kg");
        Rec."Bottle/Jar cost" := ((Rec."Total Per kg" / 1000) * Rec."Weight (in Grams)");
        Rec."Total Cost" := (Rec."Bottle/Jar cost" + Rec."Packing ( CFC- 3 ply)" + Rec."Freight till Apis ( Manglore)");
    end;
}
