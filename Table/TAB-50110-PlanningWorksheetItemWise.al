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
        field(18; "Demand Quantity FG"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Quote Comp. Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "PO Qty"; Decimal)
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

    procedure CreateIndent()
    var
        IndentHeader_Rec: Record "Pre Indent Header";
        IndentLine_Rec: Record "Pre Indent Line";
        IndentHeaderNo: Code[20];
        IndentLineNo: Integer;
        PlanningWorksheet_Loc: Record "PM Planning Item Wise";
    begin
        if not confirm('Do you want to create indent for selected Items?') then
            exit;
        PlanningWorksheet_Loc.Reset();
        PlanningWorksheet_Loc.SetFilter("Qty. for Indent", '>%1', 0);
        PlanningWorksheet_Loc.SetRange(Select, true);
        IF PlanningWorksheet_Loc.FindSet() then begin
            Clear(IndentHeaderNo);
            Clear(IndentHeader_Rec);
            IndentHeader_Rec.Init();
            IndentHeader_Rec."No." := '';
            IndentHeader_Rec.Insert(true);
            IndentHeaderNo := IndentHeader_Rec."No.";
            IndentHeader_Rec.Validate("Indent Status", IndentHeader_Rec."Indent Status"::Budgeted);
            IndentHeader_Rec.Modify();
            Clear(IndentLineNo);
            repeat
                Clear(IndentLine_Rec);
                IndentLineNo += 10000;

                IndentLine_Rec.Init();
                IndentLine_Rec.Validate("Indent No.", IndentHeaderNo);
                IndentLine_Rec.Validate("Line No", IndentLineNo);
                IndentLine_Rec.Validate(Type, IndentLine_Rec.Type::Item);
                IndentLine_Rec.Validate("No.", PlanningWorksheet_Loc."Item Code");
                IndentLine_Rec.Validate(Description, PlanningWorksheet_Loc."Item Description");
                IndentLine_Rec.Validate(Quantity, PlanningWorksheet_Loc."Qty. for Indent");
                IndentLine_Rec.Validate(UOM, PlanningWorksheet_Loc.UOM);
                IndentLine_Rec.Insert(true);

                PlanningWorksheet_Loc."Qty on Indent" += PlanningWorksheet_Loc."Qty. for Indent";
                PlanningWorksheet_Loc.Select := false;
                PlanningWorksheet_Loc."Qty. for Indent" := 0;
                PlanningWorksheet_Loc.Modify();

            until PlanningWorksheet_Loc.Next() = 0;
            Message(StrSubstNo('Indent %1-  has been Created Successfully', IndentHeaderNo));
        end else
            Message('Either entries are not selected or Qty for Indent field is 0 to create Indent.');
    end;

    procedure UpdatePlanningLines()
    var
        Location_loc: Record Location;
        Item_Loc: Record Item;
        PlanningWorksheet_Loc_1: Record "PM Planning Item Wise";
        SalesLine_Loc: Record "Sales Line";
        SOQty_Var: Decimal;
        ForecastQty_Var: Decimal;
        StockQty_var: Decimal;
    begin
        IF not Confirm('Do you want to update Planning Worksheet?') then
            exit;
        PlanningWorksheet_Loc_1.DeleteAll();
        Commit();
        Location_loc.Reset();
        Location_loc.SetRange("Reject Unit", false);
        if Location_loc.FindSet() then begin
            repeat
                Item_Loc.Reset();
                //Item_Loc.SetFilter("No.", '70063|70064|70066|70067|70068|70069');
                IF Item_Loc.FindSet() then begin
                    repeat
                        CalculateDemandNewLogic03112023(Item_Loc, Location_loc);
                    until Item_Loc.Next() = 0;
                end;
            until Location_loc.Next() = 0;
        end;

        Commit();
        Clear(PlanningWorksheet_Loc_1);
        PlanningWorksheet_Loc_1.Reset();
        IF PlanningWorksheet_Loc_1.FindSet() then begin
            repeat
                if (PlanningWorksheet_Loc_1."Actaul Demand" > PlanningWorksheet_Loc_1."Inventory on Prod. Location") then begin
                    PlanningWorksheet_Loc_1."Actaul Demand" := PlanningWorksheet_Loc_1."Actaul Demand" - PlanningWorksheet_Loc_1."Inventory on Prod. Location";
                    PlanningWorksheet_Loc_1."Inventory on Prod. Location" := 0;
                end else begin
                    PlanningWorksheet_Loc_1."Inventory on Prod. Location" := PlanningWorksheet_Loc_1."Inventory on Prod. Location" - PlanningWorksheet_Loc_1."Actaul Demand";
                    PlanningWorksheet_Loc_1."Actaul Demand" := 0;
                end;
                PlanningWorksheet_Loc_1.AssignFGDemandOnComponents(PlanningWorksheet_Loc_1);
                PlanningWorksheet_Loc_1.Modify();
            until PlanningWorksheet_Loc_1.Next() = 0;
        end;

        PlanningWorksheet_Loc_1.Reset();
        PlanningWorksheet_Loc_1.SetRange("Planning type", PlanningWorksheet_Loc_1."Planning type"::PM);
        IF PlanningWorksheet_Loc_1.FindSet() then begin
            repeat

                IF ((PlanningWorksheet_Loc_1."Actaul Demand" + PlanningWorksheet_Loc_1."Demand Quantity FG") > (PlanningWorksheet_Loc_1."PO Qty" + PlanningWorksheet_Loc_1."Quote Comp. Qty" + PlanningWorksheet_Loc_1."Inventory on Prod. Location" + PlanningWorksheet_Loc_1."Qty on Indent")) then
                    PlanningWorksheet_Loc_1."Total Demand" := ((PlanningWorksheet_Loc_1."Actaul Demand" + PlanningWorksheet_Loc_1."Demand Quantity FG") - (PlanningWorksheet_Loc_1."PO Qty" + PlanningWorksheet_Loc_1."Quote Comp. Qty" + PlanningWorksheet_Loc_1."Inventory on Prod. Location" + PlanningWorksheet_Loc_1."Qty on Indent"))
                else
                    PlanningWorksheet_Loc_1."Total Demand" := 0;

                PlanningWorksheet_Loc_1."Qty. for Indent" := PlanningWorksheet_Loc_1."Total Demand";
                PlanningWorksheet_Loc_1.Modify();
            until PlanningWorksheet_Loc_1.Next() = 0;
            Message('Planning Worksheet has been successfully updated');
        end;
        Commit();
    end;

    Procedure CalculateDemandNewLogic03112023(var Item_Loc: Record Item; Var Location_loc: Record Location)
    var
        PlanningWorksheet_Loc_1: Record "PM Planning Item Wise";
        SOQty_Var: Decimal;
        StockQty_var: Decimal;
        ForecastQty_Var: Decimal;

    begin
        Clear(SOQty_Var);
        Clear(StockQty_var);
        Clear(ForecastQty_Var);

        PlanningWorksheet_Loc_1.Reset();
        PlanningWorksheet_Loc_1.SetRange("Item Code", Item_Loc."No.");
        if not PlanningWorksheet_Loc_1.FindFirst() then begin
            PlanningWorksheet_Loc_1.Init();
            PlanningWorksheet_Loc_1."Item Code" := Item_Loc."No.";
            PlanningWorksheet_Loc_1."Item Description" := Item_Loc.Description;
            PlanningWorksheet_Loc_1."Planning type" := Item_Loc."Planning type";
            PlanningWorksheet_Loc_1.UOM := Item_Loc."Base Unit of Measure";
            PlanningWorksheet_Loc_1."Item Category Code" := Item_Loc."Item Category Code";
            PlanningWorksheet_Loc_1."Product Group Code" := Item_Loc."New Product Group Code";
            PlanningWorksheet_Loc_1."Inventory Posting Group" := Item_Loc."Inventory Posting Group";
            PlanningWorksheet_Loc_1."Qty on Indent" := CalculateQtyOnIndent(PlanningWorksheet_Loc_1."Item Code");
            PlanningWorksheet_Loc_1."PO Qty" := CalculatePOQty(PlanningWorksheet_Loc_1."Item Code");
            PlanningWorksheet_Loc_1."Quote Comp. Qty" := CalculateQuoteComparisonQty(PlanningWorksheet_Loc_1."Item Code");
            SOQty_Var := calculateSalesQtyItemLocationWise(PlanningWorksheet_Loc_1."Item Code", Location_loc.Code);
            StockQty_var := CalculateStockItemLocationWise(PlanningWorksheet_Loc_1."Item Code", Location_loc.Code);
            ForecastQty_Var := CalculateForecastQty(PlanningWorksheet_Loc_1."Item Code", Location_loc.Code);
            if (Location_loc."Production Unit" = false) then begin
                PlanningWorksheet_Loc_1."SO Qty" := SOQty_Var;
                PlanningWorksheet_Loc_1.Inventory := StockQty_var;
                PlanningWorksheet_Loc_1."Forecaste Qty." := ForecastQty_Var;
            end;

            IF ((StockQty_var - (SOQty_Var + ForecastQty_Var)) > 0) then begin
                PlanningWorksheet_Loc_1."Actual inventory" := (StockQty_var - (SOQty_Var + ForecastQty_Var));
                PlanningWorksheet_Loc_1."Actaul Demand" := 0;
            end else begin
                PlanningWorksheet_Loc_1."Actual inventory" := 0;
                PlanningWorksheet_Loc_1."Actaul Demand" := ((SOQty_Var + ForecastQty_Var) - StockQty_var);
            end;

            if (Location_loc."Production Unit" = true) then begin
                PlanningWorksheet_Loc_1."Inventory on Prod. Location" := PlanningWorksheet_Loc_1."Actual inventory";
            end;

            // IF (PlanningWorksheet_Loc_1."Actaul Demand" > (PlanningWorksheet_Loc_1."Inventory on Prod. Location" +
            // PlanningWorksheet_Loc_1."PO Qty" + PlanningWorksheet_Loc_1."Quote Comp. Qty" + PlanningWorksheet_Loc_1."Qty on Indent")) then
            //     PlanningWorksheet_Loc_1."Total Demand" := PlanningWorksheet_Loc_1."Actaul Demand" - (PlanningWorksheet_Loc_1."Inventory on Prod. Location" +
            // PlanningWorksheet_Loc_1."PO Qty" + PlanningWorksheet_Loc_1."Quote Comp. Qty" + PlanningWorksheet_Loc_1."Qty on Indent")
            // else
            //     PlanningWorksheet_Loc_1."Total Demand" := 0;

            PlanningWorksheet_Loc_1.Insert();
        end else begin
            SOQty_Var := calculateSalesQtyItemLocationWise(PlanningWorksheet_Loc_1."Item Code", Location_loc.Code);
            StockQty_var := CalculateStockItemLocationWise(PlanningWorksheet_Loc_1."Item Code", Location_loc.Code);
            ForecastQty_Var := CalculateForecastQty(PlanningWorksheet_Loc_1."Item Code", Location_loc.Code);
            if (Location_loc."Production Unit" = false) then begin
                PlanningWorksheet_Loc_1."SO Qty" += SOQty_Var;
                PlanningWorksheet_Loc_1.Inventory += StockQty_var;
                PlanningWorksheet_Loc_1."Forecaste Qty." += ForecastQty_Var;
            end;

            IF ((StockQty_var - (SOQty_Var + ForecastQty_Var)) > 0) then begin
                PlanningWorksheet_Loc_1."Actual inventory" := (StockQty_var - (SOQty_Var + ForecastQty_Var));
                PlanningWorksheet_Loc_1."Actaul Demand" += 0;
            end else begin
                PlanningWorksheet_Loc_1."Actual inventory" += 0;
                PlanningWorksheet_Loc_1."Actaul Demand" += ((SOQty_Var + ForecastQty_Var) - StockQty_var);
            end;

            if (Location_loc."Production Unit" = true) then begin
                PlanningWorksheet_Loc_1."Inventory on Prod. Location" += PlanningWorksheet_Loc_1."Actual inventory";
            end;

            // IF (PlanningWorksheet_Loc_1."Actaul Demand" > (PlanningWorksheet_Loc_1."Inventory on Prod. Location" +
            // PlanningWorksheet_Loc_1."PO Qty" + PlanningWorksheet_Loc_1."Quote Comp. Qty" + PlanningWorksheet_Loc_1."Qty on Indent")) then
            //     PlanningWorksheet_Loc_1."Total Demand" := PlanningWorksheet_Loc_1."Actaul Demand" - (PlanningWorksheet_Loc_1."Inventory on Prod. Location" +
            // PlanningWorksheet_Loc_1."PO Qty" + PlanningWorksheet_Loc_1."Quote Comp. Qty" + PlanningWorksheet_Loc_1."Qty on Indent")
            // else
            //     PlanningWorksheet_Loc_1."Total Demand" := 0;

            PlanningWorksheet_Loc_1.Modify();
        end;
    end;

    procedure AssignFGDemandOnComponents(var PlanningItemLocation_Rec: Record "PM Planning Item Wise")
    var
        Item_Loc: Record Item;
        Item_Loc_2: Record Item;
        ProdBomHeader_Rec: Record "Production BOM Header";
        ProdBomLine_Rec: Record "Production BOM Line";
        PlanningItemLocation_Loc: Record "PM Planning Item Wise";
    begin
        IF Item_Loc.Get(PlanningItemLocation_Rec."Item Code") and (Item_Loc."Production BOM No." <> '') then begin
            IF ProdBomHeader_Rec.Get(Item_Loc."Production BOM No.") and (ProdBomHeader_Rec.Status = ProdBomHeader_Rec.Status::Certified) then begin
                ProdBomLine_Rec.Reset();
                ProdBomLine_Rec.SetRange("Production BOM No.", ProdBomHeader_Rec."No.");
                ProdBomLine_Rec.SetFilter("Version Code", '');
                ProdBomLine_Rec.SetRange(Type, ProdBomLine_Rec.Type::Item);
                IF ProdBomLine_Rec.FindSet() THEN begin
                    repeat
                        PlanningItemLocation_Loc.Reset();
                        PlanningItemLocation_Loc.SetRange("Item Code", ProdBomLine_Rec."No.");
                        IF PlanningItemLocation_Loc.FindFirst() then begin
                            IF Item_Loc_2.Get(ProdBomLine_Rec."No.") and (Item_Loc_2."Production BOM No." <> '') then begin
                                // PlanningItemLocation_Loc."Total Demand" += (ProdBomLine_Rec."Quantity per" * PlanningItemLocation_Rec."Total Demand");
                                // PlanningItemLocation_Loc."Qty. for Indent" := PlanningItemLocation_Loc."Total Demand";
                                PlanningItemLocation_Loc."Demand Quantity FG" += (ProdBomLine_Rec."Quantity per" * (PlanningItemLocation_Rec."Demand Quantity FG" + PlanningItemLocation_Rec."Actaul Demand"));
                                PlanningItemLocation_Loc.AssignFGDemandOnComponents(PlanningItemLocation_Loc);
                            end else begin
                                // PlanningItemLocation_Loc."Total Demand" += (ProdBomLine_Rec."Quantity per" * PlanningItemLocation_Rec."Total Demand");
                                // PlanningItemLocation_Loc."Qty. for Indent" := PlanningItemLocation_Loc."Total Demand";
                                PlanningItemLocation_Loc."Demand Quantity FG" += (ProdBomLine_Rec."Quantity per" * (PlanningItemLocation_Rec."Demand Quantity FG" + PlanningItemLocation_Rec."Actaul Demand"));
                            end;
                            PlanningItemLocation_Loc.Modify();
                        end;
                    until ProdBomLine_Rec.Next() = 0;
                end;
            end;
        end;
    end;


    procedure CalculateStockItemLocationWise(ItemCode_Loc: Code[20]; LocationCode_Loc: code[10]): Decimal
    var
        ItemLedgerEntries_Rec: Record "Item Ledger Entry";
        ILE_Page: Page "Item Ledger Entries";
    begin
        IF (ItemCode_Loc <> '') and (LocationCode_Loc <> '') then begin
            ItemLedgerEntries_Rec.Reset();
            ItemLedgerEntries_Rec.SetCurrentKey("Item No.", Open, "Variant Code", Positive, "Location Code", "Posting Date");
            ItemLedgerEntries_Rec.SetRange("Item No.", ItemCode_Loc);
            ItemLedgerEntries_Rec.SetRange("Location Code", LocationCode_Loc);
            IF ItemLedgerEntries_Rec.FindSet() THEN begin
                ItemLedgerEntries_Rec.CalcSums(Quantity);
                exit(ItemLedgerEntries_Rec.Quantity);
            end;
        end;
    end;

    procedure CalculateForecastQty(ItemCode_Loc: Code[20]; LocationCode_Loc: code[10]): Decimal
    var
        ItemForecaste_Loc: Record "Item Forecaste Master";
        MonthNumber: Integer;
        YearValue: code[4];
    begin
        Clear(MonthNumber);
        Clear(YearValue);
        MonthNumber := Date2DMY(Today, 2);
        YearValue := Format(Date2DMY(Today, 3));

        ItemForecaste_Loc.Reset();
        ItemForecaste_Loc.SetRange("Item Code", ItemCode_Loc);
        ItemForecaste_Loc.SetRange("Location Code", LocationCode_Loc);
        ItemForecaste_Loc.SetRange(MonthInt, MonthNumber);
        ItemForecaste_Loc.SetRange(Year, YearValue);
        ItemForecaste_Loc.SetRange(Status, ItemForecaste_Loc.Status::Closed);
        IF ItemForecaste_Loc.FindFirst() then
            exit(ItemForecaste_Loc."Total Quantity");
    end;

    procedure calculateSalesQtyItemLocationWise(ItemCode_Loc: Code[20]; LocationCode_Loc: code[10]) TotSalesQty: Decimal
    var
        SalesLine_Loc: Record "Sales Line";
    begin
        Clear(TotSalesQty);
        SalesLine_Loc.Reset();
        SalesLine_Loc.SetRange("Document Type", SalesLine_Loc."Document Type"::Order);
        SalesLine_Loc.SetRange(Type, SalesLine_Loc.Type::Item);
        SalesLine_Loc.SetRange("No.", ItemCode_Loc);
        SalesLine_Loc.SetRange("Location Code", LocationCode_Loc);
        SalesLine_Loc.SetAutoCalcFields("Customer Type");
        SalesLine_Loc.SetRange("Customer Type", SalesLine_Loc."Customer Type"::B2B);
        IF SalesLine_Loc.FindSet() then begin
            repeat
                TotSalesQty += SalesLine_Loc.Quantity - SalesLine_Loc."Quantity Shipped";
            until SalesLine_Loc.Next() = 0;
        end;
        exit(TotSalesQty);
    end;

    procedure CalculateQtyOnIndent(ItemCode_Loc: Code[20]) TotalIndentQty: Decimal
    var
        PreIndentLine_Rec: Record "Pre Indent Line";
        PostedIndentLine_Rec: Record "Posted Indent Line";

    begin
        Clear(TotalIndentQty);
        PreIndentLine_Rec.Reset();
        PreIndentLine_Rec.SetCurrentKey(Status, Type, "No.");
        PreIndentLine_Rec.SetFilter(Status, '%1|%2', PreIndentLine_Rec.Status::Open, PreIndentLine_Rec.Status::"Sent for approval");
        PreIndentLine_Rec.SetRange(Type, PreIndentLine_Rec.Type::Item);
        PreIndentLine_Rec.SetRange("No.", ItemCode_Loc);
        IF PreIndentLine_Rec.FindSet() then begin
            repeat
                TotalIndentQty += PreIndentLine_Rec.Quantity;
            until PreIndentLine_Rec.Next() = 0;
        end;
        PostedIndentLine_Rec.Reset();
        PostedIndentLine_Rec.SetCurrentKey(Status, Type, "No.");
        PostedIndentLine_Rec.SetRange(Status, PostedIndentLine_Rec.Status::Approved);
        PostedIndentLine_Rec.SetRange(Type, PostedIndentLine_Rec.Type::Item);
        PostedIndentLine_Rec.SetRange("No.", ItemCode_Loc);
        IF PostedIndentLine_Rec.FindSet() then begin
            repeat
                TotalIndentQty += PostedIndentLine_Rec."Approved Qty";
            until PostedIndentLine_Rec.Next() = 0;
        end;
        exit(TotalIndentQty);
    end;

    procedure QtyOnIndentLookup()
    var
        IndentLine_Rec_Temp: Record "Pre Indent Line" temporary;
        PreIndentLine_Rec: Record "Pre Indent Line";
        PostedIndentLine_Rec: Record "Posted Indent Line";
        IndentLineListPage: page "IndentLineList";
    begin
        If IndentLine_Rec_Temp.IsTemporary then begin
            IndentLine_Rec_Temp.DeleteAll();
            PreIndentLine_Rec.Reset();
            PreIndentLine_Rec.SetCurrentKey(Status, Type, "No.");
            PreIndentLine_Rec.SetFilter(Status, '%1|%2', PreIndentLine_Rec.Status::Open, PreIndentLine_Rec.Status::"Sent for approval");
            PreIndentLine_Rec.SetRange(Type, PreIndentLine_Rec.Type::Item);
            PreIndentLine_Rec.SetRange("No.", Rec."Item Code");
            IF PreIndentLine_Rec.FindSet() then begin
                repeat
                    IndentLine_Rec_Temp.Init();
                    IndentLine_Rec_Temp.TransferFields(PreIndentLine_Rec);
                    IndentLine_Rec_Temp.Insert();
                until PreIndentLine_Rec.Next() = 0;
            end;
            PostedIndentLine_Rec.Reset();
            PostedIndentLine_Rec.SetCurrentKey(Status, Type, "No.");
            PostedIndentLine_Rec.SetRange(Status, PostedIndentLine_Rec.Status::Approved);
            PostedIndentLine_Rec.SetRange(Type, PostedIndentLine_Rec.Type::Item);
            PostedIndentLine_Rec.SetRange("No.", Rec."Item Code");
            IF PostedIndentLine_Rec.FindSet() then begin
                repeat
                    IndentLine_Rec_Temp.Init();
                    IndentLine_Rec_Temp.TransferFields(PostedIndentLine_Rec);
                    IndentLine_Rec_Temp.Insert();
                until PostedIndentLine_Rec.Next() = 0;
            end;
            IndentLine_Rec_Temp.Reset();
            IndentLine_Rec_Temp.SetRange("No.", Rec."Item Code");
            IF IndentLine_Rec_Temp.FindSet() then begin
                IndentLineListPage.SetTableView(IndentLine_Rec_Temp);
                IndentLineListPage.LookupMode(true);
                IndentLineListPage.Editable := false;
                IndentLineListPage.RunModal();
            end;
        end;
    end;


    procedure CalculatePOQty(ItemCode_Loc: Code[20]) TotalPOQty: Decimal
    var
        PurchLine_Loc: Record "Purchase Line";
    begin
        PurchLine_Loc.Reset();
        PurchLine_Loc.SetRange("Document Type", PurchLine_Loc."Document Type"::Order);
        PurchLine_Loc.SetRange(Type, PurchLine_Loc.Type::Item);
        PurchLine_Loc.SetRange("No.", ItemCode_Loc);
        IF PurchLine_Loc.FindSet() then begin
            repeat
                TotalPOQty += PurchLine_Loc.Quantity - PurchLine_Loc."Quantity Received";
            until PurchLine_Loc.Next() = 0;
        end;
        exit(TotalPOQty);
    end;

    procedure CalculateQuoteComparisonQty(ItemCode_Loc: Code[20]) TotalQuoteCompQty: Decimal
    var
        QuoteComparison_Loc: Record "Quote Comparison";
        IndentLine_Loc: Record "Posted Indent Line";
        IndentLine_Temp: Record "Posted Indent Line" temporary;
        TotalPoCreatedQty: Decimal;
        QuoteComparison_Loc_1: Record "Quote Comparison";
    begin
        IF IndentLine_Temp.IsTemporary then
            IndentLine_Temp.DeleteAll();

        QuoteComparison_Loc.Reset();
        QuoteComparison_Loc.SetFilter(Status, '%1|%2|%3', QuoteComparison_Loc.Status::Open, QuoteComparison_Loc.Status::"Pending Approval",
        QuoteComparison_Loc.Status::Approved);
        QuoteComparison_Loc.SetRange(Type, QuoteComparison_Loc.Type::Item);
        QuoteComparison_Loc.SetRange(No, ItemCode_Loc);
        if QuoteComparison_Loc.FindSet() then begin
            repeat
                If (QuoteComparison_Loc."Indent No." <> '') and (QuoteComparison_Loc."Indent Line No" > 0) then begin
                    IF not IndentLine_Temp.get(QuoteComparison_Loc."Indent No.", QuoteComparison_Loc."Indent Line No") then begin
                        IndentLine_Loc.Get(QuoteComparison_Loc."Indent No.", QuoteComparison_Loc."Indent Line No");
                        Clear(TotalPoCreatedQty);
                        QuoteComparison_Loc_1.Reset();
                        QuoteComparison_Loc_1.SetFilter(Status, '%1', QuoteComparison_Loc_1.Status::"PO Created");
                        QuoteComparison_Loc_1.SetRange("Indent No.", QuoteComparison_Loc."Indent No.");
                        QuoteComparison_Loc_1.SetRange("Indent Line No", QuoteComparison_Loc."Indent Line No");
                        IF QuoteComparison_Loc_1.FindSet() then begin
                            repeat
                                TotalPoCreatedQty += QuoteComparison_Loc_1."PO Qty.";
                            until QuoteComparison_Loc_1.Next() = 0;
                        end;

                        TotalQuoteCompQty += IndentLine_Loc."Approved Qty" - TotalPoCreatedQty;

                        // IndentLine_Temp.Init();
                        // IndentLine_Temp."Indent No." := QuoteComparison_Loc."Indent No.";
                        // IndentLine_Temp."Line No" := QuoteComparison_Loc."Indent Line No";
                        // IndentLine_Temp."Approved Qty" := IndentLine_Loc."Approved Qty" - TotalPoCreatedQty;
                        // IndentLine_Temp.Insert();
                    end;
                end else begin
                    TotalQuoteCompQty += QuoteComparison_Loc."PO Qty.";

                    // IF Not IndentLine_Temp.Get(QuoteComparison_Loc."Indent No.", QuoteComparison_Loc."Indent Line No") then begin
                    //     IndentLine_Temp.Init();
                    //     IndentLine_Temp."Indent No." := 'Blank';
                    //     IndentLine_Temp."Line No" := 10000;
                    //     IndentLine_Temp."Approved Qty" := QuoteComparison_Loc."PO Qty.";
                    //     IndentLine_Temp.Insert();
                    // end else begin
                    //     IndentLine_Temp."Approved Qty" += QuoteComparison_Loc."PO Qty.";
                    //     IndentLine_Temp.Modify();
                    // end;
                end;
            until QuoteComparison_Loc.Next() = 0;
        end;
        exit(TotalQuoteCompQty);
    end;
}