table 50107 "CZ Header"
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

        field(9; "Length Inch"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Length MM"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Width Inch"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Width MM"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Height Inch"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Height MM"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Total Length"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Total Width"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Conversion"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Printing"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Rate Per Box/PCs"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "No. of Pcs"; Integer)
        {
            DataClassification = ToBeClassified;
            InitValue = 1;
        }
        field(21; "Extra (if standy) L"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Extra (if standy) W"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Mat. In Stand"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Material in Sq. mm"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Material in Sq. cm"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(26; "Pouches in Sq. M"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(27; "For Size"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(28; "Pouch type"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(29; Layers; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Specification"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(31; "Per Pouch Wt. (Gm)"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 3;
        }
        field(32; "No. of pouch per kg"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(33; "Basic Cost Per Pouch"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 3;
        }
        field(34; "Landed Price (Rs./Kg)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(35; "Basic Material rate / Pouch"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 3;
        }
        field(36; "Wastage / Pouch"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 3;
        }
        field(37; "Pouching / Pouch"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 3;
        }
        field(38; "Zipper / Pouch"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 3;
        }
        field(39; "Landed Price / Pouch"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 3;
        }
        field(40; "Vendor Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor.Name where("No." = field("Vendor Code"));
        }
        field(41; "Total Cost"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(42; "Conversion Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(43; TotalLinePrice; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("CZ Lines".Price where("Product No." = field("Product No."), Type = field(Type), "Type Line No." = field("Type Line No.")));
        }
        field(44; TotalLineSheetWeightGM; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("CZ Lines"."Sheet Weight (GM)" where("Product No." = field("Product No."), Type = field(Type), "Type Line No." = field("Type Line No.")));
        }
        field(45; PouchTotalGSM; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("CZ Lines".GSM where("Product No." = field("Product No."), Type = field(Type), "Type Line No." = field("Type Line No.")));
        }
        field(46; PouchTotalConspt; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("CZ Lines".Conspt where("Product No." = field("Product No."), Type = field(Type), "Type Line No." = field("Type Line No.")));
        }
        field(47; PouchTotalCostPerPouch; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("CZ Lines"."Cost/Pouch" where("Product No." = field("Product No."), Type = field(Type), "Type Line No." = field("Type Line No.")));
        }
        field(48; PouchLineTotalRs; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("CZ Lines"."Total Rs" where("Product No." = field("Product No."), Type = field(Type), "Type Line No." = field("Type Line No.")));
        }
        field(49; "Basic Material rate / KG"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50; "Wastage / KG"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51; "Pouching / KG"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(52; "Pouch / KG"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(53; "Landed Price / KG"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(54; "Conversion / KG"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(55; "Conversion / Pouch"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 3;
        }
        field(56; Pouch; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(57; "Wastage"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(58; "Length Deviation"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(59; "Width Deviation"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Product No.", Type, "Vendor Code", "Main Item Code", "Type Line No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin
        InitProductNoSeries();

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    var
        CZHeader_Loc1: Record "CZ Header";
        CZHeader_Loc2: Record "CZ Header";
        CZLines_Loc1: Record "CZ Lines";
        CZLines_Loc2: Record "CZ Lines";
    begin
        IF (Rec.Type = Rec.Type::Carton) THEN begin
            CZHeader_Loc1.Reset();
            CZHeader_Loc1.SetRange("Product No.", Rec."Product No.");
            CZHeader_Loc1.SetFilter(Type, '%1|%2', CZHeader_Loc1.Type::Partition, CZHeader_Loc1.Type::Plate);
            IF CZHeader_Loc1.FindSet() then begin
                repeat
                    IF CZHeader_Loc2.Get(CZHeader_Loc1."Product No.", CZHeader_Loc1.Type, CZHeader_Loc1."Vendor Code", CZHeader_Loc1."Main Item Code",
                    CZHeader_Loc1."Type Line No.") then begin

                        CZHeader_Loc2.Rename(CZHeader_Loc1."Product No.", CZHeader_Loc1.Type, Rec."Vendor Code", Rec."Main Item Code",
                        CZHeader_Loc1."Type Line No.");

                        CZLines_Loc1.Reset();
                        CZLines_Loc1.SetRange("Product No.", CZHeader_Loc1."Product No.");
                        CZLines_Loc1.SetRange(Type, CZHeader_Loc1.Type);
                        CZLines_Loc1.SetRange("Type Line No.", CZHeader_Loc1."Type Line No.");
                        IF CZLines_Loc1.FindSet() then begin
                            repeat
                                IF CZLines_Loc2.Get(CZLines_Loc1."Product No.", CZLines_Loc1.Type, CZLines_Loc1."Type Line No.", CZLines_Loc1."Vendor Code",
                                CZLines_Loc1."Main Item Code", CZLines_Loc1."Line No.") then
                                    CZLines_Loc2.Rename(CZLines_Loc1."Product No.", CZLines_Loc1.Type, CZLines_Loc1."Type Line No.", Rec."Vendor Code",
                                Rec."Main Item Code", CZLines_Loc1."Line No.");

                            until CZLines_Loc1.Next() = 0;
                        end;
                    end;
                until CZHeader_Loc1.Next() = 0;
            end;
        end;
    end;

    local procedure InitProductNoSeries()
    var
        PurchAndPayableSetup: Record "Purchases & Payables Setup";
        NoSeriesMangt: Codeunit NoSeriesManagement;
        CZHeader_Loc: Record "CZ Header";
    begin
        IF (Rec."Product No." = '') then begin
            PurchAndPayableSetup.Get();
            IF (Rec.Type = Rec.Type::Carton) then begin
                PurchAndPayableSetup.TestField("Carton No. Series");
                Rec."Product No." := NoSeriesMangt.GetNextNo(PurchAndPayableSetup."Carton No. Series", Today, true);
            end;

            IF (Rec.Type = Rec.Type::Pouch) then begin
                PurchAndPayableSetup.TestField("Pouch No. Series");
                Rec."Product No." := NoSeriesMangt.GetNextNo(PurchAndPayableSetup."Pouch No. Series", Today, true);
            end;
        end;
    end;

    procedure CalculateCartonCostingHeader()
    var
        CZHeader_Loc1: Record "CZ Header";
    begin
        if (Rec.Type = Rec.Type::Carton) then begin
            Rec."Total Length" := Rec."Length MM" + Rec."Length MM" + Rec."Width MM" + Rec."Width MM" + Rec."Length Deviation";
            Rec."Total Width" := Rec."Width MM" + Rec."Height MM" + Rec."Width Deviation";

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
            if Rec.Modify() then;
        end;
    end;

    procedure CalculatePartitionCosting()
    begin
        if (Rec.Type = Rec.Type::Partition) then begin
            Rec."Total Length" := (Rec."Length MM" + Rec."Width MM");
            Rec."Total Width" := (Rec."Width MM" + Rec."Height MM");


            Rec.CalcFields(TotalLinePrice, TotalLineSheetWeightGM);
            Rec."Conversion Price" := (Rec.Conversion * Rec.TotalLineSheetWeightGM);
            Rec."Rate Per Box/PCs" := (Rec."Conversion Price" + Rec.Printing + Rec.TotalLinePrice);
            Rec."Total Cost" := Rec."Rate Per Box/PCs" * Rec."No. of Pcs";
            IF Rec.Modify() then;
        end;
    end;

    procedure CalculatePlateCosting()
    begin
        if (Rec.Type = Rec.Type::Plate) then begin
            Rec."Total Length" := Rec."Length MM";
            Rec."Total Width" := Rec."Width MM";

            Rec.CalcFields(TotalLinePrice, TotalLineSheetWeightGM);
            Rec."Conversion Price" := (Rec.Conversion * Rec.TotalLineSheetWeightGM);
            Rec."Rate Per Box/PCs" := (Rec."Conversion Price" + Rec.Printing + Rec.TotalLinePrice);
            Rec."Total Cost" := Rec."Rate Per Box/PCs" * Rec."No. of Pcs";
            IF Rec.Modify() then;
        end;
    end;

    procedure CalculatePouchCosting()
    begin
        if (Rec.Type = Rec.Type::Pouch) then begin
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
    end;

}