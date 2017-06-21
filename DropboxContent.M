let
    Source = (ReferencedQuery as table, token as text) =>
let
    header = [  #"Authorization"="Bearer "&token],    
    RetrieveContent = Table.AddColumn(ReferencedQuery, "Custom.1", each Web.Contents("https://content.dropboxapi.com/2/files/download",[
    Headers=[#"Dropbox-API-Arg"="{""path"":"""&[path_display]&"""}", #"Authorization" = header[Authorization]]])),
    SelectData = Table.AddColumn(RetrieveContent, "Custom", each Table.SelectRows(Excel.Workbook([Custom.1]), each [Kind]="Table")[Data]),
    ExpandAllItems = Table.ExpandListColumn(SelectData, "Custom"),
    ExpandContent = Table.ExpandTableColumn(ExpandAllItems, "Custom", List.Union(List.Transform(ExpandAllItems[Custom], each try Table.ColumnNames(_) otherwise {})))
in
ExpandContent

,documentation = [	
Documentation.Name =  "	fnDropbox.Content
", Documentation.Description = "	Returns a table with consolidated contents from Dropbox that have been retrieved by fnDropbox.TOC
" , Documentation.LongDescription = "	Returns a table with consolidated contents from Dropbox that have been retrieved by fnDropbox.TOC. 
", Documentation.Category = "	Accessing data functions
", Documentation.Source = "	local
", Documentation.Author = "	Imke Feldmann: www.TheBIccountant.com
", Documentation.Examples = {[Description =  "	
" , Code = "	Check this blogpost explaining how it works: http://wp.me/p6lgsG-AA
 ", Result = "	
"]}]	
 in	
  Value.ReplaceType(Source, Value.ReplaceMetadata(Value.Type(Source), documentation))
