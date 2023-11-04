table 50111 "Item Forecaste Master"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Item Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Item."No.";

            trigger OnValidate()
            var
                Item_Loc: Record Item;
            begin
                If (Rec."Item Code" <> '') then begin
                    Item_Loc.Get(Rec."Item Code");
                    Rec."Item Description" := Item_Loc.Description;
                end else
                    Rec."Item Description" := '';
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
            TableRelation = Location.Code;
            trigger OnValidate()
            var
                Location_Loc: Record Location;
            begin
                IF (Rec."Location Code" <> '') then begin
                    Location_Loc.Get(Rec."Location Code");
                    Rec."Location Description" := Location_Loc.Name;
                end else
                    Rec."Location Description" := '';
            end;
        }
        field(4; "Location Description"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; Month; Option)
        {
            OptionMembers = January,February,March,April,May,June,July,August,September,October,November,December;
            trigger OnValidate()
            begin
                MonthInt := ConvertMonthTextintoInteger(Month);
            end;
        }
        field(6; MonthInt; Integer)
        {
            DataClassification = ToBeClassified;
            AutoFormatType = 2;
            MinValue = 1;
        }
        field(7; Year; Code[4])
        {
            DataClassification = ToBeClassified;
            trigger OnLookup()
            var
                Date_Loc: Record Date;
                PeriodStartDate: Date;
                DateListPage: Page dateList;
            begin
                PeriodStartDate := DMY2Date(01, 01, 2020);
                Date_Loc.Reset();
                Date_Loc.SetRange("Period Type", Date_Loc."Period Type"::Year);
                Date_Loc.SetFilter("Period Start", '%1..', PeriodStartDate);
                IF Date_Loc.FindSet() then begin
                    DateListPage.SetTableView(Date_Loc);
                    DateListPage.LookupMode(true);
                    if DateListPage.RunModal() = Action::LookupOK then begin
                        DateListPage.SetSelectionFilter(Date_Loc);
                        IF Date_Loc.FindFirst() then
                            Year := Format(Date_Loc."Period No.")
                        else
                            Year := '';
                    end
                end;
            end;

            trigger OnValidate()
            var
                Date_Loc: Record Date;
                PeriodStartDate: Date;
                YearInt: Integer;
            begin
                IF not Evaluate(YearInt, Year) then
                    Error('Year must be like - 2023 or 2024');
                PeriodStartDate := DMY2Date(01, 01, YearInt);
                Date_Loc.Reset();
                Date_Loc.SetRange("Period Type", Date_Loc."Period Type"::Year);
                Date_Loc.SetRange("Period Start", PeriodStartDate);
                Date_Loc.SetRange("Period No.", YearInt);
                IF not Date_Loc.FindSet() then
                    Error('Year is not valid');
            end;
        }
        field(8; "Projected Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
            AutoFormatType = 2;
            MinValue = 0;
            trigger OnValidate()
            begin
                Rec."Total Quantity" := Rec."Projected Quantity" + Rec."Buffer Quantity";
            end;
        }
        field(9; "Buffer Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
            AutoFormatType = 2;
            MinValue = 0;
            trigger OnValidate()
            begin
                Rec."Total Quantity" := Rec."Projected Quantity" + Rec."Buffer Quantity";
            end;
        }
        field(10; "Total Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
            AutoFormatType = 2;
            MinValue = 0;
            Editable = false;
        }
        field(11; Status; Option)
        {
            OptionMembers = Open,Closed;
        }
    }

    keys
    {
        key(Key1; "Item Code", "Location Code", Month, Year)
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

    procedure ConvertMonthTextintoInteger(MonthText: Option January,February,March,April,May,June,July,August,September,October,November,December) MonthInt_Loc: Integer
    var
    begin
        case MonthText of
            monthText::January:
                begin
                    MonthInt_Loc := 1;
                end;
            monthText::February:
                begin
                    MonthInt_Loc := 2;
                end;
            monthText::March:
                begin
                    MonthInt_Loc := 3;
                end;
            monthText::April:
                begin
                    MonthInt_Loc := 4;
                end;
            monthText::May:
                begin
                    MonthInt_Loc := 5;
                end;
            monthText::June:
                begin
                    MonthInt_Loc := 6;
                end;
            monthText::July:
                begin
                    MonthInt_Loc := 7;
                end;
            monthText::August:
                begin
                    MonthInt_Loc := 8;
                end;
            monthText::September:
                begin
                    MonthInt_Loc := 9;
                end;
            monthText::October:
                begin
                    MonthInt_Loc := 10;
                end;
            monthText::November:
                begin
                    MonthInt_Loc := 11;
                end;
            monthText::December:
                begin
                    MonthInt_Loc := 12;
                end;

        end;
    end;

}