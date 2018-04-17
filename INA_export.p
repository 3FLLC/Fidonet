uses
   Strings;

var
   TFH:Text;
   Ws,Ss,Ts:String;
   StrList:TStringList;
   I:Longint;

Begin
   StrList.Init;
   AssignText(TFH, 'nodelist.082');
   Reset(TFH);
   While not EndOfText(TFH) do begin
      Ws:=ReadLnText(TFH);
      If Pos('INA:',Ws)>0 then begin
         Ts:=Ws;
         Fetch(Ws,'INA:');
         Ss:=Ws;
         If Pos(',',Ws)>0 then Ss:=Fetch(Ws,',');

         StrList.Add(Ss);
      End;
   End;
   CloseText(TFH);
   StrList.Sort;
   I:=0;
   While I<StrList.getCount-2 do begin
      if StrList.getStrings(I)=StrList.getStrings(I+1) then  StrList.Delete(I+1)
      else inc(I);
   end;
   StrList.SaveToFile('polllist.txt');
   StrList.Free;
End;
