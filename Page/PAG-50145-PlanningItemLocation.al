page 50145 "Planning Item-Location"
{
    ApplicationArea = All;
    Caption = 'Planning Item-Location Wise';
    PageType = List;
    SourceTable = "Planning Item-Location Wise";
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
                field(BOM; Rec.BOM)
                {
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Specifies the value of the Location Code field.';
                    Editable = false;
                }
                field("Location Description"; Rec."Location Description")
                {
                    ToolTip = 'Specifies the value of the Location Description field.';
                    Editable = false;
                }
                field("Production Unit"; Rec."Production Unit")
                {
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
                field("Stock Qty."; Rec."Stock Qty.")
                {
                    ToolTip = 'Specifies the value of the Stock Qty. field.';
                    Editable = false;
                    trigger OnAssistEdit()
                    var
                        ItemLedgerEntries_Rec: Record "Item Ledger Entry";
                        ILE_Page: Page "Item Ledger Entries";
                    begin
                        ItemLedgerEntries_Rec.Reset();
                        ItemLedgerEntries_Rec.SetRange("Item No.", Rec."Item Code");
                        ItemLedgerEntries_Rec.SetRange("Location Code", Rec."Location Code");
                        IF ItemLedgerEntries_Rec.FindSet() THEN begin
                            ILE_Page.SetTableView(ItemLedgerEntries_Rec);
                            ILE_Page.LookupMode(true);
                            ILE_Page.Editable := false;
                            ILE_Page.RunModal();
                        end;
                    end;
                }
                field("Demand For SO"; Rec."Demand For SO")
                {
                    ToolTip = 'Specifies the value of the Demand For SO field.';
                    Editable = false;

                    trigger OnAssistEdit()
                    var
                        InventoryPostGroup_Loc: Record "Inventory Posting Group";
                        Item_Loc: Record Item;
                        Location_Loc: Record Location;
                        SalesLine_Loc: Record "Sales Line";
                        SalesLines_Page: Page "Sales Lines";
                    begin
                        IF (Rec."Demand For SO" > 0) then begin
                            SalesLine_Loc.Reset();
                            SalesLine_Loc.SetRange("Document Type", SalesLine_Loc."Document Type"::Order);
                            SalesLine_Loc.SetRange(Type, SalesLine_Loc.Type::Item);
                            SalesLine_Loc.SetRange("No.", Rec."Item Code");
                            SalesLine_Loc.SetRange("Location Code", Rec."Location Code");
                            SalesLine_Loc.SetAutoCalcFields("Customer Type");
                            SalesLine_Loc.SetRange("Customer Type", SalesLine_Loc."Customer Type"::B2B);
                            IF SalesLine_Loc.FindSet() then begin
                                SalesLines_Page.SetTableView(SalesLine_Loc);
                                SalesLines_Page.LookupMode(true);
                                SalesLines_Page.Editable := false;
                                SalesLines_Page.RunModal();
                            end;
                        end;
                    end;
                }
                field("Pending PO Qty"; Rec."Pending PO Qty")
                {
                    ToolTip = 'Specifies the value of the Pending PO''s Qty field.';
                    Editable = false;
                    trigger OnAssistEdit()
                    var
                        PurchaseLine_Rec: Record "Purchase Line";
                        PurchaseLinesPage: page "Purchase Lines";
                    begin
                        IF (Rec."Pending PO Qty" > 0) then begin
                            PurchaseLine_Rec.Reset();
                            PurchaseLine_Rec.SetRange("Document Type", PurchaseLine_Rec."Document Type"::Order);
                            PurchaseLine_Rec.SetRange(Type, PurchaseLine_Rec.Type::Item);
                            PurchaseLine_Rec.SetRange("No.", Rec."Item Code");
                            PurchaseLine_Rec.SetRange("Location Code", Rec."Location Code");
                            IF PurchaseLine_Rec.FindSet() then begin
                                Clear(PurchaseLinesPage);
                                PurchaseLinesPage.SetTableView(PurchaseLine_Rec);
                                PurchaseLinesPage.LookupMode(true);
                                PurchaseLinesPage.Editable := false;
                                PurchaseLinesPage.RunModal();
                            end;
                        end;
                    end;
                }
                field("Actual Stock Qty."; Rec."Actual Stock Qty.")
                {
                    ToolTip = '"Actual Stock Qty" = ("Stock Qty." + "Pending PO Qty") - "Demand For SO"';
                    Editable = false;
                }
                field("Required Qty."; Rec."Required Qty.")
                {
                    ToolTip = '"Required Qty." = "Demand For SO" - ("Stock Qty." + "Pending PO Qty")';
                    Editable = false;
                }
                field("Forecaste Qty."; Rec."Forecaste Qty.")
                {
                    ToolTip = 'Specifies the value of the Forecaste Qty. field.';
                    Editable = false;

                    trigger OnAssistEdit()
                    var
                        ItemForecaste_Loc: Record "Item Forecaste Master";
                        MonthNumber: Integer;
                        YearValue: code[4];
                        ItemForeCaste_Page: Page "Item Forecast Master";
                    begin
                        Clear(MonthNumber);
                        Clear(YearValue);
                        MonthNumber := Date2DMY(Today, 2);
                        YearValue := Format(Date2DMY(Today, 3));

                        ItemForecaste_Loc.Reset();
                        ItemForecaste_Loc.SetRange("Item Code", Rec."Item Code");
                        ItemForecaste_Loc.SetRange("Location Code", Rec."Location Code");
                        ItemForecaste_Loc.SetRange(MonthInt, MonthNumber);
                        ItemForecaste_Loc.SetRange(Year, YearValue);
                        IF ItemForecaste_Loc.FindFirst() then begin
                            ItemForeCaste_Page.SetTableView(ItemForecaste_Loc);
                            ItemForeCaste_Page.LookupMode(true);
                            ItemForeCaste_Page.Editable := false;
                            ItemForeCaste_Page.RunModal();
                        end
                    end;
                }

                field("Required Qty with Forcaste"; Rec."Required Qty with Forcaste")
                {
                    ToolTip = '"Required Qty with Forcaste" = "Required Qty." + "Forcaste Qty."';
                    Editable = false;
                }
                field("Required Qty from FG Item"; Rec."Required Qty for FG Item")
                {
                    ToolTip = 'Calculated from FG items that having the item as BOM Component';
                    Editable = false;
                }
                field("Available Stock at Prod."; Rec."Available Stock at Prod.")
                {
                    Editable = false;
                    ToolTip = 'Stock available for the item at Production Unit';
                }
                field("Outstanding Stock at Prod."; Rec."Outstanding Stock at Prod.")
                {
                    Editable = false;
                }
                field("Assign Qty from Prod. Unit"; Rec."Assign Qty from Prod.")
                {
                    trigger OnValidate();
                    var
                        PlanningWorksheet_Loc: Record "Planning Item-Location Wise";
                        TotalAssignedQty: Decimal;
                    begin
                        if (Rec."Production Unit" = false) then begin
                            Clear(TotalAssignedQty);
                            PlanningWorksheet_Loc.Reset();
                            PlanningWorksheet_Loc.SetRange("Item Code", Rec."Item Code");
                            if PlanningWorksheet_Loc.FindSet() then begin
                                repeat
                                    if (PlanningWorksheet_Loc."Location Code" <> Rec."Location Code") then
                                        TotalAssignedQty += PlanningWorksheet_Loc."Assign Qty from Prod.";
                                until PlanningWorksheet_Loc.Next() = 0;
                            end;
                            if (Rec."Available Stock at Prod." - TotalAssignedQty - Rec."Assign Qty from Prod.") < 0 then
                                Error(StrSubstNo('Assigning FG item Stock has been increased by %1 Qty', ABS(Rec."Available Stock at Prod." - TotalAssignedQty - Rec."Assign Qty from Prod.")));
                            Rec."Outstanding Stock at Prod." := Rec."Available Stock at Prod." - TotalAssignedQty - Rec."Assign Qty from Prod.";
                            if (Rec."Total Required Qty." + xRec."Assign Qty from Prod." - Rec."Assign Qty from Prod.") < 0 then
                                Error('Assigned qty has been increased from total Required Qty.');
                            Rec."Total Required Qty." := Rec."Total Required Qty." + xRec."Assign Qty from Prod." - Rec."Assign Qty from Prod.";
                        end else
                            Error('Production Unit Location is not allowed to assign Qty');

                        CurrPage.Update();

                    end;
                }
                field("Total Required Qty."; Rec."Total Required Qty.")
                {
                    Editable = false;
                }

                field("Qty on Indent"; Rec."Qty on Indent")
                {
                    ToolTip = 'Specifies the value of the Qty on Indent field.';
                    Editable = false;
                    trigger OnAssistEdit()
                    var
                        IndentLine_Rec: Record "Pre Indent Line";
                        IndentLineListPage: page "IndentLineList";
                    begin
                        IF (Rec."Qty on Indent" > 0) then begin
                            IndentLine_Rec.Reset();
                            IndentLine_Rec.SetCurrentKey(Status, Type, "No.");
                            IndentLine_Rec.SetRange(Type, IndentLine_Rec.Type::Item);
                            IndentLine_Rec.SetRange("No.", Rec."Item Code");
                            IndentLine_Rec.SetRange("Location Code", Rec."Location Code");
                            IF IndentLine_Rec.FindSet() then begin
                                IndentLineListPage.SetTableView(IndentLine_Rec);
                                IndentLineListPage.LookupMode(true);
                                IndentLineListPage.Editable := false;
                                IndentLineListPage.RunModal();
                            end;
                        end;
                    end;
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
                    IF not Confirm('Do you want to Update Planning Lines?') then
                        exit;
                    UpdatePlanningItemLocationWise();
                    CurrPage.Update();
                end;
            }

            // action("test")
            // {
            //     Caption = 'Test';
            //     Ellipsis = true;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     ApplicationArea = All;

            //     trigger OnAction()
            //     var
            //         SalesHeader_Loc: Record "Sales Header";
            //         Customer_Loc: Record Customer;
            //         intvar: Integer;
            //     begin
            //         Clear(intvar);
            //         SalesHeader_Loc.Reset();
            //         IF SalesHeader_Loc.FindSet() then begin
            //             repeat
            //                 intvar += 1;
            //                 Customer_Loc.get(SalesHeader_Loc."Sell-to Customer No.");
            //                 Customer_Loc."Customer Type" := Customer_Loc."Customer Type"::B2B;
            //                 Customer_Loc.Modify();
            //             until (SalesHeader_Loc.Next() = 0) or (intvar = 15);
            //         end;
            //     end;
            // }
            action("Create Indent")
            {
                Caption = 'Create Indent';
                Ellipsis = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                var
                    IndentHeader_Rec: Record "Pre Indent Header";
                    IndentLine_Rec: Record "Pre Indent Line";
                    IndentHeaderNo: Code[20];
                    IndentLineNo: Integer;
                    PlanningItemLocation_Loc: Record "Planning Item-Location Wise";
                    Item_Loc: Record Item;
                begin
                    IF not Confirm('Do you want to create indent for selected lines?') then
                        exit;
                    PlanningItemLocation_Loc.Reset();
                    PlanningItemLocation_Loc.SetRange(Select, true);
                    PlanningItemLocation_Loc.SetFilter("Qty. for Indent", '>%1', 0);
                    IF PlanningItemLocation_Loc.FindSet() then begin
                        Clear(IndentHeaderNo);
                        Clear(IndentHeader_Rec);
                        IndentHeader_Rec.Init();
                        IndentHeader_Rec."No." := '';
                        IndentHeader_Rec.Insert(true);
                        IndentHeaderNo := IndentHeader_Rec."No.";
                        IndentHeader_Rec.Validate("Indent Status", IndentHeader_Rec."Indent Status"::Budgeted);
                        IndentHeader_Rec."Location Code" := PlanningItemLocation_Loc."Location Code";
                        IndentHeader_Rec.Modify();
                        Clear(IndentLineNo);
                        repeat
                            Clear(IndentLine_Rec);
                            IndentLineNo += 10000;

                            IndentLine_Rec.Init();
                            IndentLine_Rec.Validate("Indent No.", IndentHeaderNo);
                            IndentLine_Rec.Validate("Line No", IndentLineNo);
                            IndentLine_Rec.Validate(Type, IndentLine_Rec.Type::Item);
                            IndentLine_Rec.Validate("No.", PlanningItemLocation_Loc."Item Code");
                            IndentLine_Rec.Validate(Description, PlanningItemLocation_Loc."Item Description");
                            IndentLine_Rec.Validate("Location Code", PlanningItemLocation_Loc."Location Code");
                            IndentLine_Rec.Validate(Quantity, PlanningItemLocation_Loc."Qty. for Indent");
                            IndentLine_Rec.Validate(UOM, PlanningItemLocation_Loc.UOM);
                            Item_Loc.Get(PlanningItemLocation_Loc."Item Code");
                            IndentLine_Rec."PM Item Type" := Item_Loc."PM Item Type";
                            IndentLine_Rec.Length := Item_Loc.Length;
                            IndentLine_Rec.Width := Item_Loc.Width;
                            IndentLine_Rec.Insert(true);

                            PlanningItemLocation_Loc."Qty on Indent" += PlanningItemLocation_Loc."Qty. for Indent";
                            PlanningItemLocation_Loc.Select := false;
                            PlanningItemLocation_Loc."Qty. for Indent" := 0;
                            PlanningItemLocation_Loc.Modify();
                        until Rec.Next() = 0;
                        Message(StrSubstNo('Indent %1-  has been Created Successfully', IndentHeaderNo));
                        CurrPage.Update();
                    end else
                        Message('There is nothing to create indent');
                end;
            }
        }
    }
    procedure UpdatePlanningItemLocationWise()
    var
        InventoryPostGroup_Loc: Record "Inventory Posting Group";
        Item_Loc: Record Item;
        Item_Rec: Record Item;
        Location_Loc: Record Location;
        SalesLine_Loc: Record "Sales Line";
        Customer_Loc: Record Customer;
        PlanningItemLocation_Loc: Record "Planning Item-Location Wise";
        PlanningItemLocation_Loc_1: Record "Planning Item-Location Wise";
        PlanningItemLocation_Loc_2: Record "Planning Item-Location Wise";
        ProdBomHeader_Rec: Record "Production BOM Header";
        ProdBomLine_Rec: Record "Production BOM Line";
        FGStockQty: Decimal;

    begin
        Location_Loc.Reset();
        Location_Loc.SetRange("Production Unit", true);
        if not Location_Loc.FindSet() then
            Error('Production unit must be selected atleast on one location');

        PlanningItemLocation_Loc.Reset();
        PlanningItemLocation_Loc.DeleteAll();
        Commit();
        Clear(PlanningItemLocation_Loc);


        InventoryPostGroup_Loc.Reset();
        InventoryPostGroup_Loc.SetRange("Planning Applicable", true);
        IF InventoryPostGroup_Loc.FindSet() then begin
            repeat
                Item_Loc.Reset();
                Item_Loc.SetRange("Inventory Posting Group", InventoryPostGroup_Loc.Code);
                IF Item_Loc.FindSet() then begin
                    repeat
                        Location_Loc.Reset();
                        //Location_Loc.SetRange("Production Unit", false);
                        IF Location_Loc.FindSet() then begin
                            repeat

                                PlanningItemLocation_Loc.Reset();
                                PlanningItemLocation_Loc.SetRange("Item Code", SalesLine_Loc."No.");
                                PlanningItemLocation_Loc.SetRange("Location Code", SalesLine_Loc."Location Code");
                                IF not PlanningItemLocation_Loc.FindFirst() then begin
                                    PlanningItemLocation_Loc.Init();
                                    PlanningItemLocation_Loc."Item Code" := Item_Loc."No.";
                                    PlanningItemLocation_Loc."Item Description" := Item_Loc.Description;
                                    if Item_Loc."Production BOM No." <> '' then
                                        PlanningItemLocation_Loc.BOM := true
                                    else
                                        PlanningItemLocation_Loc.BOM := false;
                                    PlanningItemLocation_Loc."Location Code" := Location_Loc.Code;
                                    PlanningItemLocation_Loc."Location Description" := Location_Loc.Name;
                                    PlanningItemLocation_Loc."Production Unit" := Location_Loc."Production Unit";
                                    PlanningItemLocation_Loc.UOM := Item_Loc."Base Unit of Measure";
                                    PlanningItemLocation_Loc."Item Category Code" := Item_Loc."Item Category Code";
                                    PlanningItemLocation_Loc."Product Group Code" := Item_Loc."New Product Group Code";
                                    PlanningItemLocation_Loc."Inventory Posting Group" := Item_Loc."Inventory Posting Group";
                                    PlanningItemLocation_Loc."Stock Qty." := CalculateStockItemLocationWise(Item_Loc."No.", Location_Loc.Code);
                                    PlanningItemLocation_Loc."Pending PO Qty" := CalculatePendingPOQty(Item_Loc."No.", Location_Loc.Code);
                                    PlanningItemLocation_Loc."Forecaste Qty." := CalculateForecastQty(PlanningItemLocation_Loc."Item Code", PlanningItemLocation_Loc."Location Code");
                                    PlanningItemLocation_Loc."Demand For SO" += SalesLine_Loc.Quantity - SalesLine_Loc."Quantity Shipped";
                                    IF (PlanningItemLocation_Loc."Demand For SO" > (PlanningItemLocation_Loc."Stock Qty." + PlanningItemLocation_Loc."Pending PO Qty")) then begin
                                        PlanningItemLocation_Loc."Required Qty." := (PlanningItemLocation_Loc."Demand For SO" - (PlanningItemLocation_Loc."Stock Qty." + PlanningItemLocation_Loc."Pending PO Qty"));
                                        PlanningItemLocation_Loc."Actual Stock Qty." := 0;
                                    end else begin
                                        PlanningItemLocation_Loc."Required Qty." := 0;
                                        PlanningItemLocation_Loc."Actual Stock Qty." := ((PlanningItemLocation_Loc."Stock Qty." + PlanningItemLocation_Loc."Pending PO Qty") - PlanningItemLocation_Loc."Demand For SO");
                                    end;

                                    PlanningItemLocation_Loc."Required Qty with Forcaste" := PlanningItemLocation_Loc."Required Qty." + PlanningItemLocation_Loc."Forecaste Qty.";
                                    IF PlanningItemLocation_Loc.Insert() then;
                                end;

                                SalesLine_Loc.Reset();
                                SalesLine_Loc.SetRange("Document Type", SalesLine_Loc."Document Type"::Order);
                                SalesLine_Loc.SetRange(Type, SalesLine_Loc.Type::Item);
                                SalesLine_Loc.SetRange("No.", Item_Loc."No.");
                                SalesLine_Loc.SetRange("Location Code", Location_Loc.Code);
                                SalesLine_Loc.SetAutoCalcFields("Customer Type");
                                SalesLine_Loc.SetRange("Customer Type", SalesLine_Loc."Customer Type"::B2B);
                                IF SalesLine_Loc.FindSet() then begin
                                    repeat

                                        PlanningItemLocation_Loc."Demand For SO" += SalesLine_Loc.Quantity - SalesLine_Loc."Quantity Shipped";
                                        IF (PlanningItemLocation_Loc."Demand For SO" > (PlanningItemLocation_Loc."Stock Qty." + PlanningItemLocation_Loc."Pending PO Qty")) then begin
                                            PlanningItemLocation_Loc."Required Qty." := (PlanningItemLocation_Loc."Demand For SO" - (PlanningItemLocation_Loc."Stock Qty." + PlanningItemLocation_Loc."Pending PO Qty"));
                                            PlanningItemLocation_Loc."Actual Stock Qty." := 0;
                                        end else begin
                                            PlanningItemLocation_Loc."Required Qty." := 0;
                                            PlanningItemLocation_Loc."Actual Stock Qty." := ((PlanningItemLocation_Loc."Stock Qty." + PlanningItemLocation_Loc."Pending PO Qty") - PlanningItemLocation_Loc."Demand For SO");
                                        end;

                                        PlanningItemLocation_Loc."Required Qty with Forcaste" := PlanningItemLocation_Loc."Required Qty." + PlanningItemLocation_Loc."Forecaste Qty.";
                                        PlanningItemLocation_Loc.Modify();

                                    until SalesLine_Loc.Next() = 0;
                                end;
                            until Location_Loc.Next() = 0;
                        end;
                    until Item_Loc.Next() = 0;
                end;
            until InventoryPostGroup_Loc.Next() = 0;
        end;

        Commit();

        Clear(PlanningItemLocation_Loc_1);
        Clear(PlanningItemLocation_Loc_2);
        PlanningItemLocation_Loc_1.Reset();
        PlanningItemLocation_Loc_1.SetRange(BOM, true);
        if PlanningItemLocation_Loc_1.FindSet() THEN begin
            repeat
                IF Item_Loc.Get(PlanningItemLocation_Loc_1."Item Code") and (Item_Loc."Production BOM No." <> '') then begin
                    IF ProdBomHeader_Rec.Get(Item_Loc."Production BOM No.") and (ProdBomHeader_Rec.Status = ProdBomHeader_Rec.Status::Certified) then begin
                        ProdBomLine_Rec.SetRange("Production BOM No.", ProdBomHeader_Rec."No.");
                        ProdBomLine_Rec.SetFilter("Version Code", '');
                        ProdBomLine_Rec.SetRange(Type, ProdBomLine_Rec.Type::Item);
                        IF ProdBomLine_Rec.FindSet() THEN begin
                            repeat
                                PlanningItemLocation_Loc_2.Reset();
                                PlanningItemLocation_Loc_2.SetRange("Item Code", ProdBomLine_Rec."No.");
                                PlanningItemLocation_Loc_2.SetRange("Location Code", PlanningItemLocation_Loc_1."Location Code");
                                IF PlanningItemLocation_Loc_2.FindFirst() then begin
                                    PlanningItemLocation_Loc_2."Required Qty for FG Item" += (ProdBomLine_Rec."Quantity per" * PlanningItemLocation_Loc_1."Required Qty with Forcaste");
                                    PlanningItemLocation_Loc_2.Modify();
                                end;
                            until ProdBomLine_Rec.Next() = 0;
                        end;
                    end;
                end;
            until PlanningItemLocation_Loc_1.Next() = 0;
        end;

        Commit();

        Clear(PlanningItemLocation_Loc_1);
        Clear(PlanningItemLocation_Loc_2);

        PlanningItemLocation_Loc_1.Reset();
        PlanningItemLocation_Loc_1.SetRange("Production Unit", true);
        IF PlanningItemLocation_Loc.FindSet() then begin
            repeat
                IF (PlanningItemLocation_Loc_1."Actual Stock Qty." > PlanningItemLocation_Loc_1."Required Qty with Forcaste") then begin
                    Clear(FGStockQty);
                    FGStockQty := PlanningItemLocation_Loc_1."Actual Stock Qty." - PlanningItemLocation_Loc_1."Required Qty with Forcaste";
                    PlanningItemLocation_Loc_2.Reset();
                    PlanningItemLocation_Loc_2.SetRange("Production Unit", false);
                    PlanningItemLocation_Loc_2.SetRange("Item Code", PlanningItemLocation_Loc_1."Item Code");
                    IF PlanningItemLocation_Loc_2.FindSet() then
                        PlanningItemLocation_Loc_2.ModifyAll("Available Stock at Prod.", FGStockQty);
                end
            until PlanningItemLocation_Loc_1.Next() = 0;
        end;

        Commit();

        Clear(PlanningItemLocation_Loc_1);
        PlanningItemLocation_Loc_1.Reset();
        IF PlanningItemLocation_Loc_1.FindSet() then begin
            repeat
                PlanningItemLocation_Loc_1."Total Required Qty." := (PlanningItemLocation_Loc_1."Required Qty with Forcaste" + PlanningItemLocation_Loc_1."Required Qty for FG Item");
                PlanningItemLocation_Loc_1."Outstanding Stock at Prod." := PlanningItemLocation_Loc_1."Available Stock at Prod.";
                PlanningItemLocation_Loc_1.Modify();
            until PlanningItemLocation_Loc_1.Next() = 0;
        end;
        CurrPage.Update();
    end;

    trigger OnOpenPage()
    begin
        UpdateValuesLinewise();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        UpdateValuesLinewise();
    end;

    trigger OnAfterGetRecord()
    begin
        UpdateValuesLinewise();
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

    procedure UpdateValuesLinewise()
    var
        PlanningWorksheet_Loc_1: Record "Planning Item-Location Wise";
        TotalAssignedQty: Decimal;
    begin
        if (Rec."Production Unit" = false) then begin
            Clear(TotalAssignedQty);
            PlanningWorksheet_Loc_1.Reset();
            PlanningWorksheet_Loc_1.SetRange("Item Code", Rec."Item Code");
            if PlanningWorksheet_Loc_1.FindSet() then begin
                repeat
                    TotalAssignedQty += PlanningWorksheet_Loc_1."Assign Qty from Prod.";
                until PlanningWorksheet_Loc_1.Next() = 0;
            end;
            IF ((Rec."Available Stock at Prod." - TotalAssignedQty) < 0) then
                Error(StrSubstNo('Assigning FG item Stock has been increased by %1 Qty', ABS(Rec."Available Stock at Prod." - TotalAssignedQty)));
            Rec."Outstanding Stock at Prod." := (Rec."Available Stock at Prod." - TotalAssignedQty);
        end;
    end;

    procedure CalculatePendingPOQty(ItemCode_Loc: Code[20]; LocationCode_Loc: code[10]) PoPendingQty_Loc: Decimal
    var
        PurchaseLine_Loc: Record "Purchase Line";
    begin
        Clear(PoPendingQty_Loc);
        PurchaseLine_Loc.Reset();
        PurchaseLine_Loc.SetRange("Document Type", PurchaseLine_Loc."Document Type"::Order);
        PurchaseLine_Loc.SetRange(Type, PurchaseLine_Loc.Type::Item);
        PurchaseLine_Loc.SetRange("No.", ItemCode_Loc);
        PurchaseLine_Loc.SetRange("Location Code", LocationCode_Loc);
        IF PurchaseLine_Loc.FindSet() then
            repeat
                PoPendingQty_Loc += PurchaseLine_Loc.Quantity - PurchaseLine_Loc."Quantity Received";
            until PurchaseLine_Loc.Next() = 0;
        exit(PoPendingQty_Loc);
    end;
}