table 50105 "BCL Costing Master"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Vendor Code"; Code[20])
        {
            TableRelation = Vendor."No.";
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                Vendor_Loc: Record Vendor;
            begin
                IF Vendor_Loc.Get(Rec."Vendor Code") then
                    Rec."Vendor Name" := Vendor_Loc.Name;
            end;
        }
        field(2; "Item Code"; Code[20])
        {
            TableRelation = Item."No.";
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                Item_Loc: Record Item;
            begin
                IF (Rec."Item Code" <> '') then begin
                    Item_Loc.Get(Rec."Item Code");
                    Rec."Item Name" := Item_Loc.Description;
                end else
                    Rec."Item Name" := '';
            end;
        }
        field(3; "Item Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Weight (in Grams)"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 4;
        }
        field(7; "Neck Size"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 4;
        }
        field(8; "Resin price (RELPET G 5801)/kg"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 4;
        }
        field(9; "Preform conversion/kg"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 4;
        }
        field(10; "Blowing conversion/kg"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 4;
        }
        field(11; "Total Conversion per kg"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 4;
        }
        field(12; "Total Per kg"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 4;
        }
        field(13; "Bottle/Jar cost"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 4;
        }
        field(14; "Packing ( CFC- 3 ply)"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 4;
        }
        field(15; "Individual poly bag"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 4;
        }
        field(16; "Freight till Apis ( Manglore)"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 4;
        }
        field(17; "Total Cost"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 2;
        }

        //>>CAP
        field(18; "No. of Cavity"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "RM TYPE"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "RM COST LANDED"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 4;
        }
        field(21; "Master Batch Rs.480 Per KG"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 4;
        }
        field(22; "Weight of Cap (In Grams)"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 4;
        }
        field(23; "RM COST"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 4;
        }
        field(24; "Master Batch cost/Pcs"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 4;
        }
        field(25; "Conversion@Per Pcs"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 4;
        }
        field(26; "Rejection@2%"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 4;
        }
        field(27; "Rejection/Pcs"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 4;
        }
        field(28; "Fitting Charges"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 4;
        }
        field(29; "Packing charges"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 4;
        }
        field(30; "Packing charges (Carton)"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 4;
        }
        field(31; "Freight"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 4;
        }
        field(32; "PROFIT @10%"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 4;
        }
        field(33; "Cap in each carton"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 4;
        }
        field(34; "Carton"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 4;
        }
        field(35; "Poly"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 4;
        }
        field(36; "Tape"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 4;
        }
        field(37; "Patti"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 4;
        }
        field(38; "Lock"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 4;
        }
        field(39; "freight local"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 4;
        }
        field(40; "For Roorkee"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 4;
        }
        //<<CAP
        //>>Label
        field(41; "Substrate Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(42; "Substrate Type"; Code[50])
        {
            TableRelation = "Substrate-Paper Quality Master".Code where(Type = filter(Substrate));
            DataClassification = ToBeClassified;
        }
        field(43; "Qty From"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 4;
        }
        field(44; "Qty To"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 4;
        }
        field(45; "Sq.inch Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 4;
        }
        //<<Label
        field(46; "Unit of Production for PO"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(47; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Bottle,Cap,Label;
        }
        field(48; "Vendor Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }


    }

    keys
    {
        key(Key1; Type, "Vendor Code", "Substrate Code", "Substrate Type", "Item Code", "Start Date", "End Date")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin
        Rec.TestField("Vendor Code");
        IF (Rec.Type <> Rec.Type::Label) then
            Rec.TestField("Item Code");
        Rec.TestField("Start Date");
        Rec.TestField("End Date");

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