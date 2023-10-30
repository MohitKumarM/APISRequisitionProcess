//>>----------------Documentation-------------------
//Created this page for Calculating Planning for Packing Material short on the basis of inventory and sales orders finished goods

//Field mapping for the used temporary table
//"Automatic Ext. Texts"		"No."		Description	"Base Unit of Measure"		"Item Category Code"	"Product Group Code"	Inventory Posting Group		"Unit Price"		"Unit Cost"	        "Standard Cost"		"Unit List Price"	"Rolled-up Material Cost"    Rec."Last Direct Cost"
//Select				        Item No.	Description	Item UOM			        Item Category Code	    Product Group Code	    Inventory Posting group		Total Stock Qty.	Total Demand for SO	Pending PO's		Qty on Indent		 Remaining /Required Qty.    "Qty. for Indent"

//<<-----------------------------------------------------


page 50114 "PM Planning Worksheet1"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Item;
    Caption = 'PM Planning Worksheet';
    SourceTableTemporary = true;
    InsertAllowed = false;
    DeleteAllowed = false;


    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Item No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Description"; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Item UOM"; Rec."Base Unit of Measure")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Inventory Posting Group"; Rec."Inventory Posting Group")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Product Group Code"; Rec."New Product Group Code")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Total Stock Qty."; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    Caption = 'Total Stock Qty.';
                    Editable = false;

                    trigger OnAssistEdit()
                    var
                        ItemLedgerEntries_Rec: Record "Item Ledger Entry";
                        ILE_Page: Page "Item Ledger Entries";
                    begin
                        ItemLedgerEntries_Rec.Reset();
                        ItemLedgerEntries_Rec.SetRange("Item No.", Rec."No.");
                        IF ItemLedgerEntries_Rec.FindSet() THEN begin
                            ILE_Page.SetTableView(ItemLedgerEntries_Rec);
                            ILE_Page.LookupMode(true);
                            ILE_Page.Editable := false;
                            ILE_Page.RunModal();
                        end;
                    end;
                }
                field("Total Demand for SO"; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                    Caption = 'Total Demand for SO';
                    Editable = false;
                }
                field("Pending PO's"; Rec."Standard Cost")
                {
                    ApplicationArea = All;
                    Caption = 'Pending PO Qty';
                    Editable = false;

                    trigger OnAssistEdit()
                    var
                        PurchaseLine_Rec: Record "Purchase Line";
                        PurchaseLinesPage: page "Purchase Lines";
                    begin
                        IF (Rec."Standard Cost" > 0) then begin
                            PurchaseLine_Rec.Reset();
                            PurchaseLine_Rec.SetRange("Document Type", PurchaseLine_Rec."Document Type"::Order);
                            PurchaseLine_Rec.SetRange(Type, PurchaseLine_Rec.Type::Item);
                            PurchaseLine_Rec.SetRange("No.", Rec."No.");
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
                field("Qty on Indent"; Rec."Unit List Price")
                {
                    ApplicationArea = All;
                    Caption = 'Qty on Indent';
                    Editable = false;

                    trigger OnAssistEdit()
                    var
                        IndentLine_Rec: Record "Pre Indent Line";
                        IndentLineListPage: page "IndentLineList";
                    begin
                        IndentLine_Rec.Reset();
                        IndentLine_Rec.SetCurrentKey(Status, Type, "No.");
                        IndentLine_Rec.SetRange(Type, IndentLine_Rec.Type::Item);
                        IndentLine_Rec.SetRange("No.", Rec."No.");
                        IF IndentLine_Rec.FindSet() then begin
                            IndentLineListPage.SetTableView(IndentLine_Rec);
                            IndentLineListPage.LookupMode(true);
                            IndentLineListPage.Editable := false;
                            IndentLineListPage.RunModal();

                        end;
                    end;
                }
                field("Remaining / Required Qty."; Rec."Rolled-up Material Cost")
                {
                    ApplicationArea = All;
                    Caption = 'Required Qty.';
                    Editable = false;
                }
                field("Select"; Rec."Automatic Ext. Texts")
                {
                    ApplicationArea = All;
                    Caption = 'Select';
                }
                field("Qty. for Indent"; Rec."Last Direct Cost")
                {
                    ApplicationArea = All;
                    Caption = 'Qty. for Indent';

                    trigger OnValidate()
                    var
                    begin
                        IF (Rec."Last Direct Cost" > Rec."Rolled-up Material Cost") then
                            Error(StrSubstNo('Qty. for Indent must be less than or Equal to Required Qty. i.e -%1', Rec."Rolled-up Material Cost"));
                    end;
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
                    IndentHeader_Rec: Record "Pre Indent Header";
                    IndentLine_Rec: Record "Pre Indent Line";
                begin
                    Update_PM_Planning_Worksheet();

                    if Rec.IsTemporary then begin
                        Rec.Reset();
                        IF Rec.FindSet() THEN begin
                            Repeat
                                IndentLine_Rec.Reset();
                                IndentLine_Rec.SetCurrentKey(Status, Type, "No.");
                                IndentLine_Rec.SetRange(Type, IndentLine_Rec.Type::Item);
                                IndentLine_Rec.SetRange("No.", Rec."No.");
                                IF IndentLine_Rec.FindSet() then begin
                                    IndentLine_Rec.CalcSums(Quantity);
                                    Rec."Unit List Price" := IndentLine_Rec.Quantity;
                                    Rec.Modify();
                                end;
                            until Rec.Next() = 0;
                        end;

                        CurrPage.Update();
                    end;
                end;
            }

            action("Create Indent1")
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
                begin
                    IF Rec.IsTemporary then begin
                        Rec.Reset();
                        Rec.SetRange("Automatic Ext. Texts", true);
                        Rec.SetFilter("Last Direct Cost", '>%1', 0);
                        IF Rec.FindSet() then begin

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
                                IndentLine_Rec.Validate("No.", Rec."No.");
                                IndentLine_Rec.Validate(Description, Rec.Description);
                                IndentLine_Rec.Validate(Quantity, Rec."Last Direct Cost");
                                IndentLine_Rec.Validate(UOM, Rec."Base Unit of Measure");
                                IndentLine_Rec.Insert(true);

                                Rec."Unit List Price" += Rec."Last Direct Cost";
                                Rec."Automatic Ext. Texts" := false;
                                Rec."Last Direct Cost" := 0;
                                Rec.Modify();
                            until Rec.Next() = 0;
                            Rec.Reset();
                            Message(StrSubstNo('Indent %1-  has been Created Successfully', IndentHeaderNo));
                            //CurrPage.Update();
                        end else
                            Message('There is nothing to create indent');
                    end;
                end;
            }
        }
    }

    local procedure Update_PM_Planning_Worksheet()
    var
        SalesLine_Rec: Record "Sales Line";
        Item_Rec: Record Item;
        Item_TempRec1: Record Item temporary;
        INvPostGrp_Rec: Record "Inventory Posting Group";
        ProdBomHeader_Rec: Record "Production BOM Header";
        ProdBomLine_Rec: Record "Production BOM Line";
        PurchLine_Rec: Record "Purchase Line";
        Inventory_Var: Decimal;
        BOM_Inventory_Var: Decimal;
        BOM_Demand_Qty_Var: Decimal;
    begin
        IF Rec.IsTemporary then Begin
            Rec.DeleteAll();

            IF Item_TempRec1.IsTemporary then
                Item_TempRec1.DeleteAll();

            Commit();

            SalesLine_Rec.Reset();
            SalesLine_Rec.SetCurrentKey(Type, "No.");
            SalesLine_Rec.SetRange("Document Type", SalesLine_Rec."Document Type"::Order);
            SalesLine_Rec.SetRange(Type, SalesLine_Rec.Type::Item);
            IF SalesLine_Rec.FindSet() THEN begin
                repeat
                    IF Item_Rec.Get(SalesLine_Rec."No.") then;
                    IF INvPostGrp_Rec.Get(Item_Rec."Inventory Posting Group") and INvPostGrp_Rec."Planning Applicable" THEN begin
                        IF not Item_TempRec1.Get(SalesLine_Rec."No.") THEN begin
                            Item_TempRec1.Init();
                            Item_TempRec1."No." := Item_Rec."No.";
                            Item_TempRec1.Description := Item_Rec.Description;
                            Item_TempRec1."Base Unit of Measure" := SalesLine_Rec."Unit of Measure Code";
                            Item_TempRec1."Item Category Code" := SalesLine_Rec."Item Category Code";
                            Item_TempRec1."New Product Group Code" := Item_Rec."New Product Group Code";
                            Item_TempRec1."Inventory Posting Group" := Item_Rec."Inventory Posting Group";
                            Item_TempRec1."Unit Cost" := (SalesLine_Rec.Quantity - SalesLine_Rec."Quantity Shipped");
                            Item_TempRec1.Insert();
                        end else begin
                            Item_TempRec1."Unit Cost" += (SalesLine_Rec.Quantity - SalesLine_Rec."Quantity Shipped");
                            Item_TempRec1.Modify();
                        end;
                    end;
                until SalesLine_Rec.next() = 0;
            end;

            Item_TempRec1.Reset();
            IF Item_TempRec1.FindSet() then begin
                repeat
                    Clear(Inventory_Var);
                    Item_Rec.Get(Item_TempRec1."No.");
                    Item_Rec.CalcFields(Inventory);
                    Inventory_Var := Item_Rec.Inventory;

                    IF (Item_TempRec1."Unit Cost" > Inventory_Var) then begin
                        Item_TempRec1."Unit Cost" := Item_TempRec1."Unit Cost" - Inventory_Var;
                        IF ProdBomHeader_Rec.Get(Item_Rec."Production BOM No.") and (ProdBomHeader_Rec.Status = ProdBomHeader_Rec.Status::Certified) then begin
                            ProdBomLine_Rec.Reset();
                            ProdBomLine_Rec.SetRange("Production BOM No.", ProdBomHeader_Rec."No.");
                            ProdBomLine_Rec.SetFilter("Version Code", '');
                            ProdBomLine_Rec.SetRange(Type, ProdBomLine_Rec.Type::Item);
                            IF ProdBomLine_Rec.FindSet() THEN begin
                                repeat
                                    Item_Rec.Get(ProdBomLine_Rec."No.");
                                    Item_Rec.CalcFields(Inventory);
                                    BOM_Inventory_Var := Item_Rec.Inventory;

                                    BOM_Demand_Qty_Var := ProdBomLine_Rec."Quantity per" * Item_TempRec1."Unit Cost";

                                    IF (BOM_Inventory_Var < BOM_Demand_Qty_Var) then begin

                                        IF not Rec.Get(ProdBomLine_Rec."No.") then begin
                                            Rec.Init();
                                            Rec."No." := ProdBomLine_Rec."No.";
                                            Rec.Description := ProdBomLine_Rec.Description;
                                            Rec."Base Unit of Measure" := ProdBomLine_Rec."Unit of Measure Code";
                                            Rec."Item Category Code" := Item_Rec."Item Category Code";
                                            Rec."New Product Group Code" := Item_Rec."New Product Group Code";
                                            Rec."Inventory Posting Group" := Item_Rec."Inventory Posting Group";
                                            Rec."Unit Price" := BOM_Inventory_Var;
                                            Rec."Unit Cost" := ProdBomLine_Rec."Quantity per" * Item_TempRec1."Unit Cost";

                                            PurchLine_Rec.Reset();
                                            PurchLine_Rec.SetRange("Document Type", PurchLine_Rec."Document Type"::Order);
                                            PurchLine_Rec.SetRange(Type, PurchLine_Rec.Type::Item);
                                            PurchLine_Rec.SetFilter("No.", Rec."No.");
                                            IF PurchLine_Rec.FindSet() then begin
                                                repeat
                                                    Rec."Standard Cost" += PurchLine_Rec.Quantity - PurchLine_Rec."Quantity Received";
                                                until PurchLine_Rec.Next() = 0;
                                            end;


                                            Rec."Rolled-up Material Cost" := Abs((Rec."Unit Price" - Rec."Unit Cost") + Rec."Standard Cost");
                                            Rec.Insert();
                                        end else begin
                                            Rec."Unit Cost" += ProdBomLine_Rec."Quantity per" * Item_TempRec1."Unit Cost";
                                            Rec."Rolled-up Material Cost" := Abs((Rec."Unit Price" - Rec."Unit Cost") + Rec."Standard Cost");
                                            Rec.Modify();
                                        end;
                                    end;
                                until ProdBomLine_Rec.Next() = 0;
                            end;
                        end else begin
                            //>>Non BOM Item
                            Item_Rec.Get(Item_TempRec1."No.");
                            IF not Rec.Get(Item_Rec."No.") then begin
                                Rec.Init();
                                Rec."No." := Item_Rec."No.";
                                Rec.Description := Item_Rec.Description;
                                Rec."Base Unit of Measure" := Item_Rec."Base Unit of Measure";
                                Rec."Item Category Code" := Item_Rec."Item Category Code";
                                Rec."New Product Group Code" := Item_Rec."New Product Group Code";
                                Rec."Inventory Posting Group" := Item_Rec."Inventory Posting Group";
                                Rec."Unit Price" := Inventory_Var;
                                Rec."Unit Cost" := Item_TempRec1."Unit Cost";

                                PurchLine_Rec.Reset();
                                PurchLine_Rec.SetRange("Document Type", PurchLine_Rec."Document Type"::Order);
                                PurchLine_Rec.SetRange(Type, PurchLine_Rec.Type::Item);
                                PurchLine_Rec.SetFilter("No.", Item_Rec."No.");
                                IF PurchLine_Rec.FindSet() then begin
                                    repeat
                                        Rec."Standard Cost" += PurchLine_Rec.Quantity - PurchLine_Rec."Quantity Received";
                                    until PurchLine_Rec.Next() = 0;
                                end;

                                Rec."Rolled-up Material Cost" := Abs((Rec."Unit Price" - Rec."Unit Cost") + Rec."Standard Cost");
                                Rec."Automatic Ext. Texts" := false;
                                Rec.Insert();
                            end else begin
                                Rec."Automatic Ext. Texts" := false;
                                Rec."Unit Cost" += Item_TempRec1."Unit Cost";
                                Rec."Rolled-up Material Cost" := Abs((Rec."Unit Price" - Rec."Unit Cost") + Rec."Standard Cost");
                                Rec.Modify();
                            end;
                            //<<
                        end;
                    end;
                until Item_TempRec1.Next() = 0;
            end;
        end;
        Message('Planning Worksheet has been calculated successfully');
    end;

    trigger OnOpenPage()
    begin

    end;


    var
        myInt: Integer;
}