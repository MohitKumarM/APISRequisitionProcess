pageextension 79910 ExtendTemplatePage extends 250
{
    layout
    {
        // Add changes to page layout here
    }



    /*   // Add changes to page actions here
      trigger OnOpenPage()
      begin


                  usersetup.Get(UserId);
                  IF usersetup."Security Center Filter" <> '' THEN BEGIN
                      Rec.FILTERGROUP(2);
                      Rec.setrange(Type, Rec.Type::Indent);
                      rec.SETRANGE("Security Center Codes", usersetup."Security Center Filter");
                      Rec.FILTERGROUP(0);
                  END;




      end; */

    var
        usersetup: Record "User Setup";
        PostedIndentLine: Record "Posted Indent Line";
        IndentPage: page "Posted Indent For PO";

}