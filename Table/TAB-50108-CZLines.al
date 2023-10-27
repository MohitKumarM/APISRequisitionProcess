table 50108 "CZ Lines"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Product No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Type; Option)
        {
            OptionMembers = Carton,Partition,Plate,Pouch;
            DataClassification = ToBeClassified;
        }
        field(3; "Type Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Vendor Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No.";
            trigger OnValidate()
            var
                Vendor_Loc: Record Vendor;
            begin
                IF (Rec."Vendor Code" <> '') then begin
                    Vendor_Loc.Get(Rec."Vendor Code");
                    Rec."Vendor Name" := Vendor_Loc.Name;
                end else
                    Rec."Vendor Name" := '';
            end;
        }
        field(5; "Main Item Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Item."No.";

            trigger OnValidate()
            var
                Item_Loc: Record Item;
            begin
                IF (Rec."Main Item Code" <> '') then begin
                    Item_Loc.Get(Rec."Main Item Code");
                    Rec."Main Item Name" := Item_Loc.Description;
                end else
                    Rec."Main Item Name" := '';
            end;
        }
        field(6; "Main Item Name"; Text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(7; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "End date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Vendor Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(11; "Quality Paper Code"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = if (Type = filter(Carton)) "Substrate-Paper Quality Master".Code where(Type = filter(Carton)) else
            if (Type = filter(Partition)) "Substrate-Paper Quality Master".Code where(Type = filter(Partition)) else
            if (Type = filter(Plate)) "Substrate-Paper Quality Master".Code where(Type = filter(Plate)) else
            if (Type = filter(Pouch)) "Substrate-Paper Quality Master".Code where(Type = filter(Pouch));

            trigger OnValidate()
            var
                SubstratePaperQualityMaster: Record "Substrate-Paper Quality Master";
                CZHeader_Loc: Record "CZ Header";
            begin
                SubstratePaperQualityMaster.Reset();
                SubstratePaperQualityMaster.SetRange(Type, Rec.Type);
                SubstratePaperQualityMaster.SetRange(Code, "Quality Paper Code");
                IF SubstratePaperQualityMaster.FindSet() then begin
                    Rec."Quality Paper Description" := SubstratePaperQualityMaster.Description;
                end;

                CZHeader_Loc.Reset();
                CZHeader_Loc.SetRange("Product No.", Rec."Product No.");
                CZHeader_Loc.SetRange(Type, Rec.Type);
                CZHeader_Loc.SetRange("Type Line No.", Rec."Type Line No.");
                CZHeader_Loc.SetRange("Main Item Code", Rec."Main Item Code");
                CZHeader_Loc.SetRange("Vendor Code", Rec."Vendor Code");
                IF CZHeader_Loc.FindFirst() THen begin
                    Rec.Validate(Length, CZHeader_Loc."Total Length");
                    Rec.Validate(Width, CZHeader_Loc."Total Width");
                end;
            end;
        }
        field(12; "Quality Paper Description"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(13; Length; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14; Width; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Area (Sq Mtr)"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 4;
        }
        field(16; GSM; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 4;
        }
        field(17; "Box GSM"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 4;
        }
        field(18; "Wastage 4%"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 4;
        }
        field(19; "Sheet Weight (GM)"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 4;
        }
        field(20; "Rate of Papar"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 4;
        }
        field(21; Price; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 2;
        }

        field(23; Micron; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(24; Density; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Rate(Rs/Kg)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(26; Conspt; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(27; "Cost/Pouch"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(28; "Total Rs"; Decimal)
        {
            DataClassification = ToBeClassified;
        }

    }


    keys
    {
        key(Key1; "Product No.", Type, "Type Line No.", "Vendor Code", "Main Item Code", "Start Date", "End date", "Line No.")
        {
            Clustered = true;
        }
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