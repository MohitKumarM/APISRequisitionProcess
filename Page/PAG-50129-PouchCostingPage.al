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
                field("Width MM"; Rec."Width MM")
                {
                    trigger OnValidate()
                    begin
                        Rec.CalculatePouchCosting();
                    end;

                }
                field("Length MM"; Rec."Length MM")
                {
                    trigger OnValidate()
                    begin
                        Rec.CalculatePouchCosting();
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
                SubPageLink = "Product No." = field("Product No."), Type = field(Type), "Type Line No." = field("Type Line No."), "Vendor Code" = field("Vendor Code"), "Main Item Code" = field("Main Item Code");
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
                        Rec.CalculatePouchCosting();
                    end;
                }
                field(Zipper; Rec.Pouch)
                {
                    trigger OnValidate()
                    begin
                        Rec.CalculatePouchCosting();
                    end;
                }
                field(Conversion; Rec.Conversion)
                {
                    trigger OnValidate()
                    begin
                        Rec.CalculatePouchCosting();
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
                            Rec.CalculatePouchCosting();
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
        Rec.CalculatePouchCosting();
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.CalculatePouchCosting();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        Rec.CalculatePouchCosting();
    end;


}
