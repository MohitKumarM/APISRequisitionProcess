page 50117 LabelCostingMaster
{
    ApplicationArea = All;
    Caption = 'Label Costing Master';
    PageType = List;
    SourceTable = "BCL Costing Master";
    SourceTableView = where(Type = filter(Label));
    UsageCategory = Lists;
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Vendor Code"; Rec."Vendor Code")
                {
                    ToolTip = 'Specifies the value of the Vendor Code field.';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {

                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Start Date field.';
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field.';
                }
                field("Substrate Code"; Rec."Substrate Code")
                {
                    ToolTip = 'Specifies the value of the Substrate Code field.';
                }
                field("Substrate Type"; Rec."Substrate Type")
                {
                    ToolTip = 'Specifies the value of the Substrate Type field.';
                }
                field("Qty From"; Rec."Qty From")
                {
                    ToolTip = 'Specifies the value of the Qty From field.';
                }
                field("Qty To"; Rec."Qty To")
                {
                    ToolTip = 'Specifies the value of the Qty To field.';
                }
                field("Sq.inch Rate"; Rec."Sq.inch Rate")
                {
                    ToolTip = 'Specifies the value of the Sq.inch Rate field.';
                }
            }
        }
    }
}
