table 50110 "Planning Item-Location Wise"
{
    Caption = 'Planning Worksheet Item-Location Wise';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Item Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            trigger OnValidate()
            var
            begin

            end;

        }
        field(2; "Item Description"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;

        }
        field(3; "Location Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = Location;
            trigger OnValidate()
            var
            begin

            end;
        }
        field(4; "Location Description"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; UOM; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Unit of Measure";
            ValidateTableRelation = false;
        }
        field(6; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
        }

        field(7; "Product Group Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "New Product Group".Code where("Item Category Code" = field("Item Category Code"));
        }
        field(8; "Inventory Posting Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Inventory Posting Group';
            TableRelation = "Inventory Posting Group";
        }
        field(9; "Stock Qty."; Decimal)
        {
            AutoFormatType = 2;
            MinValue = 0;
            DataClassification = ToBeClassified;
        }
        field(10; "Demand For SO"; Decimal)
        {
            AutoFormatType = 2;
            MinValue = 0;
            DataClassification = ToBeClassified;
        }
        field(11; "Pending PO Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
            AutoFormatType = 2;
            MinValue = 0;
        }
        field(12; "Qty on Indent"; Decimal)
        {
            DataClassification = ToBeClassified;
            AutoFormatType = 2;
            MinValue = 0;

        }
        field(13; "Required Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
            AutoFormatType = 2;
            MinValue = 0;
        }
        field(14; "Qty. for Indent"; Decimal)
        {
            DataClassification = ToBeClassified;
            AutoFormatType = 2;
            MinValue = 0;
        }
        field(15; Select; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Forecaste Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
            AutoFormatType = 2;
            MinValue = 0;
        }
        field(17; "Total Required Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
            AutoFormatType = 2;
            MinValue = 0;
        }
        field(18; "Production Unit"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Actual Stock Qty."; Decimal)
        {
            AutoFormatType = 2;
            MinValue = 0;
            DataClassification = ToBeClassified;
        }

        field(21; "BOM"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Required Qty with Forcaste"; Decimal)
        {
            DataClassification = ToBeClassified;
            AutoFormatType = 2;
            MinValue = 0;
        }
        field(23; "Required Qty for FG Item"; Decimal)
        {
            DataClassification = ToBeClassified;
            AutoFormatType = 2;
            MinValue = 0;
        }
        field(24; "Available Stock at Prod."; Decimal)
        {
            DataClassification = ToBeClassified;
            AutoFormatType = 2;
            MinValue = 0;
        }
        field(25; "Assign Qty from Prod."; Decimal)
        {
            DataClassification = ToBeClassified;
            AutoFormatType = 2;
            MinValue = 0;
        }
        field(26; "Outstanding Stock at Prod."; Decimal)
        {
            DataClassification = ToBeClassified;
            AutoFormatType = 2;
            MinValue = 0;
        }
    }

    keys
    {
        key(Key1; "Item Code", "Location Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}