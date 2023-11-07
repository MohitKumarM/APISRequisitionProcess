table 50106 "Substrate-Paper Quality Master"
{
    Caption = 'Substrate-Paper Quality Maste';
    DataClassification = ToBeClassified;
    DrillDownPageId = "Paper Master";
    LookupPageId = "Paper Master";

    fields
    {
        field(1; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Carton,Partition,Plate,Pouch,Substrate;
        }
        field(2; "Code"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Description"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Vendor Code"; Code[20])
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
        field(5; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Vendor Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8; "Rate of Paper"; Decimal)
        {
            DataClassification = ToBeClassified;
            AutoFormatType = 2;
            MinValue = 0;
        }
    }

    keys
    {
        key(Key1; Type, Code, "Vendor Code", "Start Date", "End Date")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnModify()
    var
        czlines: Record "CZ Lines";
    begin
        IF (Rec.Type <> Rec.Type::Substrate) and (Rec."Rate of Paper" > 0) then begin
            czlines.Reset();
            czlines.SetRange(Type, Rec.Type);
            czlines.SetRange("Quality Paper Code", Rec.Code);
            czlines.SetRange("Vendor Code", Rec."Vendor Code");
            if czlines.FindSet() then begin
                repeat
                    if Rec.Type = Rec.Type::Pouch then
                        czlines.Validate("Rate(Rs/Kg)", Rec."Rate of Paper")
                    else
                        czlines.Validate("Rate of Papar", Rec."Rate of Paper");
                    czlines.Modify();
                until czlines.Next() = 0;
            end;
        end;
    end;

    trigger onRename()
    var
        czlines: Record "CZ Lines";
    begin
        IF (Rec.Type <> Rec.Type::Substrate) and (Rec."Rate of Paper" > 0) then begin
            czlines.Reset();
            czlines.SetRange(Type, Rec.Type);
            czlines.SetRange("Quality Paper Code", Rec.Code);
            czlines.SetRange("Vendor Code", Rec."Vendor Code");
            if czlines.FindSet() then begin
                repeat
                    if Rec.Type = Rec.Type::Pouch then
                        czlines.Validate("Rate(Rs/Kg)", Rec."Rate of Paper")
                    else
                        czlines.Validate("Rate of Papar", Rec."Rate of Paper");
                    czlines.Modify();
                until czlines.Next() = 0;
            end;
        end;
    end;
}