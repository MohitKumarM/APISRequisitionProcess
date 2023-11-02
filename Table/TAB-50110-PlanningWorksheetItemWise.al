table 50110 "PM Planning Item Wise"
{
    Caption = 'PM Planning Worksheet Item Wise';
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

        field(3; UOM; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Unit of Measure";
            ValidateTableRelation = false;
        }
        field(4; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
        }

        field(5; "Product Group Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "New Product Group".Code where("Item Category Code" = field("Item Category Code"));
        }
        field(6; "Inventory Posting Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Inventory Posting Group';
            TableRelation = "Inventory Posting Group";
        }
        field(7; "SO Qty"; Decimal)
        {
            AutoFormatType = 2;
            MinValue = 0;
            DataClassification = ToBeClassified;
        }
        field(8; Inventory; Decimal)
        {
            AutoFormatType = 2;
            MinValue = 0;
            DataClassification = ToBeClassified;
        }
        field(9; "Forecaste Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
            AutoFormatType = 2;
            MinValue = 0;
        }
        field(10; "Actaul Demand"; Decimal)
        {
            DataClassification = ToBeClassified;
            AutoFormatType = 2;
            MinValue = 0;
        }
        field(11; "Inventory on Prod. Location"; Decimal)
        {
            DataClassification = ToBeClassified;
            AutoFormatType = 2;
            MinValue = 0;
        }
        field(12; "Total Demand"; Decimal)
        {
            DataClassification = ToBeClassified;
            AutoFormatType = 2;
            MinValue = 0;
        }

        field(13; "Qty on Indent"; Decimal)
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
        field(16; "Planning type"; option)
        {
            OptionMembers = "FG-Honey","FG-Non Honey",PM,"RM-Honey","RM-NonHoney";
        }
        field(17; "Actual inventory"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Item Code")
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