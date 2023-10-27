page 50129 "Pouch Costing"
{
    ApplicationArea = All;
    Caption = 'Pouch Costing';
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "CZ Header";
    SourceTableView = where(Type = filter(Pouch));

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

                }
                field("End date"; Rec."End date")
                {
                    ToolTip = 'Specifies the value of the End date field.';
                    ShowMandatory = true;
                }
                field("Width MM"; Rec."Width MM")
                {
                    trigger OnValidate()
                    begin
                        CalculatePouchCosting();
                    end;

                }
                field("Length MM"; Rec."Length MM")
                {
                    trigger OnValidate()
                    begin
                        CalculatePouchCosting();
                    end;

                }
                field("Extra (if standy) L"; Rec."Extra (if standy) L")
                {

                }
                field("Extra (if standy) W"; Rec."Extra (if standy) W")
                {

                }
                field("Mat. In Stand"; Rec."Mat. In Stand")
                {

                }
                field("Material in Sq. mm"; Rec."Material in Sq. mm")
                {
                    Editable = false;
                }
                field("Material in Sq. cm"; Rec."Material in Sq. cm")
                {
                    Editable = false;
                }
                field("Pouches in Sq. M"; Rec."Pouches in Sq. M")
                {
                    Editable = false;
                }
                field("For Size"; Rec."For Size")
                {

                }
                field("Pouch type"; Rec."Pouch type")
                {

                }
                field(Layers; Rec.Layers)
                {

                }
                field(Specification; Rec.Specification)
                {

                }
            }

            part(PouchLines; "Pouch Lines")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "Product No." = field("Product No."), Type = field(Type), "Type Line No." = field("Type Line No."), "Vendor Code" = field("Vendor Code"), "Main Item Code" = field("Main Item Code"), "Start Date" = field("Start Date"), "End date" = field("End date");
                UpdatePropagation = Both;
            }
            group("Per Pouch/KG")
            {
                field("Per Pouch Wt. (Gm)"; Rec."Per Pouch Wt. (Gm)")
                {
                    Editable = false;
                }
                field("No. of pouch per kg"; Rec."No. of pouch per kg")
                {
                    Editable = false;
                }

                field("Wastage %"; Rec.Wastage)
                {
                    Caption = 'Wastage %';
                    trigger OnValidate()
                    begin
                        CalculatePouchCosting();
                    end;
                }
                field(Pouch; Rec.Pouch)
                {
                    trigger OnValidate()
                    begin
                        CalculatePouchCosting();
                    end;
                }
                field(Conversion; Rec.Conversion)
                {
                    trigger OnValidate()
                    begin
                        CalculatePouchCosting();
                    end;
                }
                field("Basic Cost Per Pouch"; Rec."Basic Cost Per Pouch")
                {
                    Editable = false;
                }
                field("Landed Price (Rs./Kg)"; Rec."Landed Price (Rs./Kg)")
                {
                    Editable = false;
                }

                group("Per Pouch")
                {
                    field("Basic Material rate / Pouch"; Rec."Basic Material rate / Pouch")
                    {
                        Editable = false;
                    }
                    field("Wastage / Pouch"; Rec."Wastage / Pouch")
                    {
                        Editable = false;

                    }
                    field("Pouching / Pouch"; Rec."Pouching / Pouch")
                    {
                        Editable = false;

                    }
                    field("Zipper / Pouch"; Rec."Zipper / Pouch")
                    {
                        Editable = false;
                    }
                    field("Conversion / Pouch"; Rec."Conversion / Pouch")
                    {
                        Editable = false;

                    }

                    field("Landed Price / Pouch"; Rec."Landed Price / Pouch")
                    {
                        Editable = false;

                    }

                }
                group("Per KG")
                {
                    field("Basic Material rate / KG"; Rec."Basic Material rate / KG")
                    {
                        Editable = false;
                    }
                    field("Wastage / KG"; Rec."Wastage / KG")
                    {
                        Editable = false;

                    }

                    field("Pouching / KG"; Rec."Pouching / KG")
                    {
                        trigger OnValidate()
                        begin
                            CalculatePouchCosting();
                        end;
                    }
                    field("Pouch / KG"; Rec."Pouch / KG")
                    {
                        Editable = false;
                    }

                    field("Conversion / KG"; Rec."Conversion / KG")
                    {
                        Editable = false;
                    }

                    field("Landed Price / KG"; Rec."Landed Price / KG")
                    {
                        Editable = false;
                    }

                }

            }

        }
    }
    var


    trigger OnOpenPage()
    begin
        CalculatePouchCosting();
    end;

    trigger OnAfterGetRecord()
    begin
        CalculatePouchCosting();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CalculatePouchCosting();
    end;

    procedure CalculatePouchCosting()
    begin
        Rec."Material in Sq. mm" := (Rec."Width MM" * Rec."Length MM");
        Rec."Material in Sq. cm" := (Rec."Material in Sq. mm" / 100);
        IF (Rec."Material in Sq. mm" <> 0) then
            Rec."Pouches in Sq. M" := (10000 / Rec."Material in Sq. cm");

        Rec.CalcFields(PouchTotalGSM, PouchTotalConspt, PouchTotalCostPerPouch, PouchLineTotalRs);

        Rec."Per Pouch Wt. (Gm)" := Rec.PouchTotalConspt;
        IF (Rec."Per Pouch Wt. (Gm)" <> 0) then
            Rec."No. of pouch per kg" := (1000 / Rec."Per Pouch Wt. (Gm)");

        Rec."Basic Material rate / Pouch" := Rec.PouchTotalCostPerPouch;
        IF (Rec.PouchTotalGSM <> 0) then
            Rec."Basic Material rate / KG" := (Rec.PouchLineTotalRs / Rec.PouchTotalGSM);
        Rec."Wastage / Pouch" := (Rec."Basic Material rate / Pouch" * (Rec.Wastage / 100));
        Rec."Wastage / KG" := (Rec."Basic Material rate / KG" * (Rec.Wastage / 100));
        IF (Rec."No. of pouch per kg" <> 0) then
            Rec."Pouching / Pouch" := (Rec."Pouching / KG" / Rec."No. of pouch per kg");
        Rec."Zipper / Pouch" := ((Rec."Length MM" / 25.4) * Rec.Pouch);
        Rec."Pouch / KG" := (Rec."Zipper / Pouch" * Rec."No. of pouch per kg");
        IF (Rec."No. of pouch per kg" <> 0) then
            Rec."Conversion / Pouch" := (Rec.Conversion / Rec."No. of pouch per kg");
        Rec."Conversion / KG" := Rec.Conversion;
        Rec."Landed Price / Pouch" := (Rec."Basic Material rate / Pouch" + Rec."Wastage / Pouch" + Rec."Pouching / Pouch" +
        Rec."Zipper / Pouch" + Rec."Conversion / Pouch");
        Rec."Landed Price / KG" := (Rec."Basic Material rate / KG" + Rec."Wastage / KG" + Rec."Pouching / KG" +
        Rec."Pouch / KG" + Rec."Conversion / KG");
        Rec."Basic Cost Per Pouch" := Rec."Landed Price / Pouch";
        Rec."Landed Price (Rs./Kg)" := Rec."Landed Price / KG";
        If Rec.Modify() then;

    end;

}
