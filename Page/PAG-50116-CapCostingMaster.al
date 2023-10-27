page 50116 CapCostingMaster
{
    ApplicationArea = All;
    Caption = 'Cap Costing Master';
    PageType = List;
    SourceTable = "BCL Costing Master";
    SourceTableView = where(Type = filter(Cap));
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
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Start Date field.';
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field.';
                }
                field("No. of Cavity"; Rec."No. of Cavity")
                {
                    ToolTip = 'Specifies the value of the No. of Cavity field.';
                    trigger OnValidate()
                    begin
                        CalculateCapCosting();
                    end;
                }
                field("RM TYPE"; Rec."RM TYPE")
                {
                    ToolTip = 'Specifies the value of the RM TYPE field.';
                }
                field("RM COST LANDED"; Rec."RM COST LANDED")
                {
                    ToolTip = 'Specifies the value of the RM COST LANDED field.';
                    trigger OnValidate()
                    begin
                        CalculateCapCosting();
                    end;
                }
                field("Master Batch Rs.480 Per KG"; Rec."Master Batch Rs.480 Per KG")
                {
                    ToolTip = 'Specifies the value of the Master Batch Rs.480 Per KG field.';
                    trigger OnValidate()
                    begin
                        CalculateCapCosting();
                    end;
                }
                field("Cap in each carton"; Rec."Cap in each carton")
                {
                    ToolTip = 'Specifies the value of the Cap in each carton field.';
                    trigger OnValidate()
                    begin
                        CalculateCapCosting();
                    end;
                }
                field("Weight of Cap (In Grams)"; Rec."Weight of Cap (In Grams)")
                {
                    ToolTip = 'Specifies the value of the Weight of Cap (In Grams) field.';
                    trigger OnValidate()
                    begin
                        CalculateCapCosting();
                    end;
                }
                field(Poly; Rec.Poly)
                {
                    ToolTip = 'Specifies the value of the Poly field.';
                    trigger OnValidate()
                    begin
                        CalculateCapCosting();
                    end;
                }

                field("Rejection@2%"; Rec."Rejection@2%")
                {
                    ToolTip = 'Specifies the value of the Rejection@2% field.';
                    trigger OnValidate()
                    begin
                        CalculateCapCosting();
                    end;
                }

                field("Fitting Charges"; Rec."Fitting Charges")
                {
                    ToolTip = 'Specifies the value of the Fitting Charges field.';
                    trigger OnValidate()
                    begin
                        CalculateCapCosting();
                    end;
                }
                field("RM COST"; Rec."RM COST")
                {
                    ToolTip = 'Specifies the value of the RM COST field.';
                    Editable = false;
                }
                field("Master Batch cost/Pcs"; Rec."Master Batch cost/Pcs")
                {
                    ToolTip = 'Specifies the value of the Master Batch cost/Pcs field.';
                    Editable = false;

                }
                field("Conversion@Per Pcs"; Rec."Conversion@Per Pcs")
                {
                    ToolTip = 'Specifies the value of the Conversion@Per Pcs field.';
                    Editable = false;
                }
                field("Rejection/Pcs"; Rec."Rejection/Pcs")
                {
                    ToolTip = 'Specifies the value of the Rejection/Pcs field.';
                    Editable = false;
                }
                field("Packing charges (Poly) +Tape+Patti+lock"; Rec."Packing charges")
                {
                    ToolTip = 'Specifies the value of the Packing charges field.';
                    Editable = false;
                }
                field("Packing charges (Carton)"; Rec."Packing charges (Carton)")
                {
                    ToolTip = 'Specifies the value of the Packing charges (Carton) field.';
                    Editable = false;
                }
                field(Freight; Rec.Freight)
                {
                    ToolTip = 'Specifies the value of the Freight field.';
                    Editable = false;
                }
                field("PROFIT @10%"; Rec."PROFIT @10%")
                {
                    ToolTip = 'Specifies the value of the PROFIT @10% field.';
                    Editable = false;
                }

                field(Carton; Rec.Carton)
                {
                    ToolTip = 'Specifies the value of the Carton field.';
                    Editable = false;
                }

                field(Tape; Rec.Tape)
                {
                    ToolTip = 'Specifies the value of the Tape field.';
                    Editable = false;
                }
                field(Patti; Rec.Patti)
                {
                    ToolTip = 'Specifies the value of the Patti field.';
                    Editable = false;
                }
                field(Lock; Rec.Lock)
                {
                    ToolTip = 'Specifies the value of the Lock field.';
                    Editable = false;
                }
                field("freight local"; Rec."freight local")
                {
                    ToolTip = 'Specifies the value of the freight local field.';
                    Editable = false;
                }
                field("Freight For Roorkee"; Rec."For Roorkee")
                {
                    ToolTip = 'Specifies the value of the For Roorkee field.';
                    Editable = false;
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
        CalculateCapCosting();
    end;

    trigger OnAfterGetRecord()
    begin
        CalculateCapCosting();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CalculateCapCosting();
    end;

    local procedure CalculateCapCosting()
    var
    begin
        IF Rec."Cap in each carton" > 0 then
            Rec.Carton := (60 / Rec."Cap in each carton");
        IF Rec."Cap in each carton" > 0 then
            Rec.Tape := (7.2 / Rec."Cap in each carton");
        IF Rec."Cap in each carton" > 0 then
            Rec.Patti := (13.35 / Rec."Cap in each carton");
        IF Rec."Cap in each carton" > 0 then
            Rec.Lock := (1.8 / Rec."Cap in each carton");

        Rec."RM COST" := Round(((Rec."Weight of Cap (In Grams)" * Rec."RM COST LANDED") / 1000), 0.01, '=');
        Rec."Master Batch cost/Pcs" := Round(((Rec."Master Batch Rs.480 Per KG" * Rec."Weight of Cap (In Grams)") / 1000), 0.01, '=');
        IF Rec."No. of Cavity" > 0 then
            Rec."Conversion@Per Pcs" := Round((1 / Rec."No. of Cavity"), 0.01, '=');
        Rec."Rejection/Pcs" := Round(((Rec."RM COST" + Rec."Master Batch cost/Pcs") * (Rec."Rejection@2%" / 100)), 0.01, '=');
        Rec."Packing charges" := Round((Rec.Poly + Rec.Tape + Rec.Patti + Rec.Lock), 0.01, '=');
        Rec."Packing charges (Carton)" := Rec.Carton;

        IF Rec."Cap in each carton" > 0 then
            Rec."freight local" := Round((100 / (Rec."Cap in each carton" * 9)), 0.01, '=');
        IF Rec."Cap in each carton" > 0 then
            Rec."For Roorkee" := Round((130 / Rec."Cap in each carton"), 0.01, '=');
        Rec.Freight := (Rec."freight local" + Rec."For Roorkee");

        Rec."PROFIT @10%" := ((Rec."RM COST" + Rec."Master Batch cost/Pcs" + Rec."Conversion@Per Pcs" + (Rec."Rejection@2%" / 100) + Rec."Rejection/Pcs" +
                             Rec."Fitting Charges" + Rec."Packing charges" + Rec."Packing charges (Carton)" + Rec.Freight) * 10 / 100);
        Rec."Total Cost" := (Rec."RM COST" + Rec."Master Batch cost/Pcs" + Rec."Conversion@Per Pcs" + Rec."Rejection/Pcs" +
                            Rec."Fitting Charges" + Rec."Packing charges" + Rec."Packing charges (Carton)" + Rec.Freight + Rec."PROFIT @10%");

    end;
}
