page 50145 "PM Planning Worksheet"
{
    ApplicationArea = All;
    Caption = 'PM Planning Worksheet';
    PageType = List;
    SourceTable = "PM Planning Item Wise";
    UsageCategory = Lists;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Item Code"; Rec."Item Code")
                {
                    ToolTip = 'Specifies the value of the Item Code field.';
                    Editable = false;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ToolTip = 'Specifies the value of the Item Description field.';
                    Editable = false;
                }
                field(UOM; Rec.UOM)
                {
                    ToolTip = 'Specifies the value of the UOM field.';
                    Editable = false;
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ToolTip = 'Specifies the value of the Item Category Code field.';
                    Editable = false;
                }
                field("Product Group Code"; Rec."Product Group Code")
                {
                    ToolTip = 'Specifies the value of the Product Group Code field.';
                    Editable = false;
                }
                field("Inventory Posting Group"; Rec."Inventory Posting Group")
                {
                    ToolTip = 'Specifies the value of the Inventory Posting Group field.';
                    Editable = false;
                }
                field("SO Qty"; Rec."SO Qty")
                {
                    ToolTip = 'Specifies the value of the SO Qty field.';
                    Editable = false;
                }
                field(Inventory; Rec.Inventory)
                {
                    ToolTip = 'Specifies the value of the Inventory field.';
                    Editable = false;
                }
                field("Forecaste Qty."; Rec."Forecaste Qty.")
                {
                    ToolTip = 'Specifies the value of the Forecaste Qty. field.';
                    Editable = false;
                }
                field("Actaul Demand"; Rec."Actaul Demand")
                {
                    ToolTip = 'Specifies the value of the Actaul Demand field.';
                    Editable = false;
                }
                field("Inventory on Prod. Location"; Rec."Inventory on Prod. Location")
                {
                    ToolTip = 'Specifies the value of the Inventory on Prod. Location field.';
                    Editable = false;
                }
                field("Total Demand"; Rec."Total Demand")
                {
                    ToolTip = 'Specifies the value of the Total Demand field.';
                    Editable = false;
                }
                field("Qty on Indent"; Rec."Qty on Indent")
                {
                    ToolTip = 'Specifies the value of the Qty on Indent field.';
                    Editable = false;
                }
                field("Qty. for Indent"; Rec."Qty. for Indent")
                {
                    ToolTip = 'Specifies the value of the Qty. for Indent field.';
                }
                field(Select; Rec.Select)
                {
                    ToolTip = 'Specifies the value of the Select field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Update Planning Lines")
            {
                Caption = 'Update Planning Lines';
                Ellipsis = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;
                trigger OnAction()
                var
                begin
                    UpdatePlanningLines();
                    CurrPage.Update();
                end;
            }

            action("Create Indent")
            {
                Caption = 'Create Indent';
                Ellipsis = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    CreateIndent();
                    CurrPage.Update();
                end;
            }
        }
    }

    procedure CreateIndent()
    var
        IndentHeader_Rec: Record "Pre Indent Header";
        IndentLine_Rec: Record "Pre Indent Line";
        IndentHeaderNo: Code[20];
        IndentLineNo: Integer;
        PlanningWorksheet_Loc: Record "PM Planning Item Wise";
    begin

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
            Message('There is nothing to create indent');
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
        Location_loc.Reset();
        Location_loc.SetRange("Reject Unit", false);
        if Location_loc.FindSet() then begin
            repeat
                Item_Loc.Reset();
                IF Item_Loc.FindSet() then begin
                    repeat
                        Clear(SOQty_Var);
                        Clear(StockQty_var);
                        Clear(ForecastQty_Var);
                        PlanningWorksheet_Loc_1.Reset();
                        PlanningWorksheet_Loc_1.SetRange("Item Code", Item_Loc."No.");
                        if not PlanningWorksheet_Loc_1.FindFirst() then begin
                            PlanningWorksheet_Loc_1.Init();
                            PlanningWorksheet_Loc_1."Item Code" := Item_Loc."No.";
                            PlanningWorksheet_Loc_1."Item Description" := Item_Loc.Description;
                            PlanningWorksheet_Loc_1.UOM := Item_Loc."Base Unit of Measure";
                            PlanningWorksheet_Loc_1."Item Category Code" := Item_Loc."Item Category Code";
                            PlanningWorksheet_Loc_1."Product Group Code" := Item_Loc."New Product Group Code";
                            PlanningWorksheet_Loc_1."Inventory Posting Group" := Item_Loc."Inventory Posting Group";
                            SOQty_Var := calculateSalesQtyItemLocationWise(PlanningWorksheet_Loc_1."Item Code", Location_loc.Code);
                            StockQty_var := CalculateStockItemLocationWise(PlanningWorksheet_Loc_1."Item Code", Location_loc.Code);
                            ForecastQty_Var := CalculateForecastQty(PlanningWorksheet_Loc_1."Item Code", Location_loc.Code);
                            PlanningWorksheet_Loc_1."SO Qty" := SOQty_Var;
                            PlanningWorksheet_Loc_1.Inventory := StockQty_var;
                            PlanningWorksheet_Loc_1."Forecaste Qty." := ForecastQty_Var;

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
                            PlanningWorksheet_Loc_1.Insert();
                        end else begin
                            PlanningWorksheet_Loc_1."SO Qty" := calculateSalesQtyItemLocationWise(PlanningWorksheet_Loc_1."Item Code", Location_loc.Code);
                            PlanningWorksheet_Loc_1.Inventory := CalculateStockItemLocationWise(PlanningWorksheet_Loc_1."Item Code", Location_loc.Code);
                            PlanningWorksheet_Loc_1."Forecaste Qty." := CalculateForecastQty(PlanningWorksheet_Loc_1."Item Code", Location_loc.Code);
                            IF ((PlanningWorksheet_Loc_1."SO Qty" + PlanningWorksheet_Loc_1."Forecaste Qty.") > PlanningWorksheet_Loc_1.Inventory) then
                                PlanningWorksheet_Loc_1."Actaul Demand" += ((PlanningWorksheet_Loc_1."SO Qty" + PlanningWorksheet_Loc_1."Forecaste Qty.") - PlanningWorksheet_Loc_1.Inventory);


                            PlanningWorksheet_Loc_1.Modify();
                        end;
                    until Item_Loc.Next() = 0;
                end;

            until Location_loc.Next() = 0;
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
}
