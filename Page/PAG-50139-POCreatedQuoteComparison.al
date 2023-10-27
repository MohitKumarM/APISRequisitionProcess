page 50139 "PO Created Quote Comparison"
{
    ApplicationArea = All;
    Caption = 'PO Created Quote Comparison';
    PageType = List;
    SourceTable = "Quote Comparison";
    SourceTableView = where(Status = filter("PO Created"));
    UsageCategory = History;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {

                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field("PO No."; Rec."PO No.")
                {

                }
                field("PO Line No."; Rec."PO Line No.")
                {

                }

                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field(No; Rec.No)
                {
                    ToolTip = 'Specifies the value of the No field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }

                field("Vendor Code"; Rec."Vendor Code")
                {
                    ToolTip = 'Specifies the value of the Vendor Code field.';
                }

                field("Vendor Name"; Rec."Vendor Name")
                {
                    ToolTip = 'Specifies the value of the Vendor Name field.';
                }
                field("Indent No."; Rec."Indent No.")
                {
                    ToolTip = 'Specifies the value of the Indent No. field.';
                }
                field("Indent Line No"; Rec."Indent Line No")
                {
                    ToolTip = 'Specifies the value of the Indent Line No field.';
                }
                field("Indent Approved Quantity"; Rec."Indent Approved Quantity")
                {
                    ToolTip = 'Specifies the value of the Indent Approved Quantity field.';
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ToolTip = 'Specifies the value of the Unit Cost field.';
                }
                field("Total Indent Qty. Cost"; Rec."Total Indent Qty. Cost")
                {
                    ToolTip = 'Specifies the value of the Total Cost field.';
                }
                field("Substrate Code"; Rec."Substrate Code")
                {
                    ToolTip = 'Specifies the value of the Substrate Code field.';
                }
                field("Substrate Type"; Rec."Substrate Type")
                {
                    ToolTip = 'Specifies the value of the Substrate Type field.';
                }
                field(Length; Rec.Length)
                {
                    ToolTip = 'Specifies the value of the Length field.';
                }
                field(Width; Rec.Width)
                {
                    ToolTip = 'Specifies the value of the Width field.';
                }
                field("Area (Sq Mtr)"; Rec."Area (Sq Mtr)")
                {
                    ToolTip = 'Specifies the value of the Area (Sq Mtr) field.';
                }
                field(Freight; Rec.Freight)
                {
                    ToolTip = 'Specifies the value of the Freight field.';
                }
                field("Delivery Days"; Rec."Delivery Days")
                {
                    ToolTip = 'Specifies the value of the Delivery Days field.';
                }
                field("Payment Term"; Rec."Payment Term")
                {
                    ToolTip = 'Specifies the value of the Payment Term field.';
                }
                field("Priority No."; Rec."Priority No.")
                {
                    ToolTip = 'Specifies the value of the Priority No. field.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("PO Qty."; Rec."PO Qty.")
                {
                    ToolTip = 'Specifies the value of the PO Qty. field.';
                }
                field("Total PO Qty. Cost"; Rec."Total PO Qty. Cost")
                {
                    ToolTip = 'Specifies the value of the Total PO Qty. Cost field.';
                }
                field("Outstanding Qty."; Rec."Outstanding Qty.")
                {
                    ToolTip = 'Specifies the value of the OutStanding Qty. field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field("Approver Remarks"; Rec."Approver Remarks")
                {
                    ToolTip = 'Specifies the value of the Approver Remarks field.';
                }
                field("Sender UserID"; Rec."Sender UserID")
                {
                    ToolTip = 'Specifies the value of the Sender UserID field.';
                }
                field("Send DateTime"; Rec."Send DateTime")
                {
                    ToolTip = 'Specifies the value of the Send DateTime field.';
                }
                field("Approver UserID"; Rec."Approver UserID")
                {
                    ToolTip = 'Specifies the value of the Approver UserID field.';
                }

            }
        }
    }
    var

}
